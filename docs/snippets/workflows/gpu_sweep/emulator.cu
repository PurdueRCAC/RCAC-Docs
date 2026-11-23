// FILENAME: emulator.cu
// A stand-in for training one small climate emulator on a GPU.
// "./emulator 17" runs member 17 of the sweep: it holds 1 GiB of GPU
// memory and runs 50 training steps. Each step is a short burst of GPU
// work followed by a pause, as if the CPU were preparing the next batch
// of data. It writes one line about the run to results/member_0017.txt.
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <cuda_runtime.h>

#define MEMORY_MIB 1024  // GPU memory each member holds
#define STEPS 50         // training steps per member
#define WORK 2000        // GPU work per step, per element
#define PAUSE_US 60000   // CPU time per step, in microseconds

__global__ void train_step(float *weights, size_t n)
{
    size_t i = blockIdx.x * (size_t) blockDim.x + threadIdx.x;
    if (i < n) {
        float w = weights[i];
        for (int k = 0; k < WORK; k++)
            w = w * 0.999f + 0.001f;
        weights[i] = w;
    }
}

static double seconds(void)
{
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec / 1e9;
}

int main(int argc, char **argv)
{
    int member = argc > 1 ? atoi(argv[1]) : 0;
    size_t n = (size_t) MEMORY_MIB * 1024 * 1024 / sizeof(float);
    unsigned int blocks = (unsigned int) ((n + 255) / 256);
    const char *slot = getenv("TASK_SLOT");
    char gpu[32] = "unknown";
    char path[64];
    float *weights;
    double start = seconds();
    cudaError_t err;
    FILE *out;

    err = cudaMalloc((void **) &weights, n * sizeof(float));
    if (err != cudaSuccess) {
        fprintf(stderr, "member %d: cannot hold %d MiB on the GPU: %s\n",
                member, MEMORY_MIB, cudaGetErrorString(err));
        return 2;
    }
    cudaMemset(weights, 0, n * sizeof(float));
    cudaDeviceGetPCIBusId(gpu, sizeof gpu, 0);

    for (int step = 0; step < STEPS; step++) {
        train_step<<<blocks, 256>>>(weights, n);
        err = cudaDeviceSynchronize();
        if (err != cudaSuccess) {
            fprintf(stderr, "member %d: step %d failed: %s\n",
                    member, step, cudaGetErrorString(err));
            return 3;
        }
        usleep(PAUSE_US);
    }
    cudaFree(weights);

    snprintf(path, sizeof path, "results/member_%04d.txt", member);
    out = fopen(path, "w");
    if (out == NULL) {
        perror(path);
        return 4;
    }
    fprintf(out, "member=%d gpu=%s slot=%s seconds=%.1f\n",
            member, gpu, slot ? slot : "none", seconds() - start);
    fclose(out);
    return 0;
}
