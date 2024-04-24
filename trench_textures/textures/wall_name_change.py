import os
import re

directory = "."
pattern = "Wall_"
correct_files = []
for filename in os.listdir(directory):
    if re.search(pattern, filename):
        correct_files.append(filename)

index = 1
for filename in correct_files:
    new_filename = filename.replace(
        filename, str("wall_1_" + "{:02d}".format(index) + ".png")
    )
    old_path = os.path.join(directory, filename)
    new_path = os.path.join(directory, new_filename)
    os.rename(old_path, new_path)
    index += 1
