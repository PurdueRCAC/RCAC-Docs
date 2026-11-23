# Where the work runs: Slurm jobs ("blocks") of one whole node each, on Gautschi's cpu partition.
from parsl.config import Config
from parsl.executors import HighThroughputExecutor
from parsl.providers import SlurmProvider

config = Config(
    executors=[
        HighThroughputExecutor(
            label="cpu",
            provider=SlurmProvider(
                account="myallocation",
                partition="cpu",
                qos="normal",
                nodes_per_block=1,
                init_blocks=1,
                min_blocks=0,
                max_blocks=2,
                walltime="01:00:00",
                worker_init="source ~/parsl-env/bin/activate",
            ),
        )
    ]
)
