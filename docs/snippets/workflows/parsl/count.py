# What runs: one task per input file, then a summary that waits for all of them.
import glob
import os

import parsl
from parsl import bash_app

from config import config


@bash_app
def count_words(path, result):
    return f"wc -w {path} > {result}"


@bash_app
def summarize(results, inputs=()):
    return "cat " + " ".join(results) + " > summary.txt"


if __name__ == "__main__":
    os.makedirs("results", exist_ok=True)
    with parsl.load(config):
        paths = sorted(glob.glob("data/*.txt"))
        results = ["results/" + os.path.basename(p).replace(".txt", ".count") for p in paths]
        counts = [count_words(p, r) for p, r in zip(paths, results)]
        summarize(results, inputs=counts).result()
