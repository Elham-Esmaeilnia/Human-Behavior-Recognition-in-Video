# Human Behavior Recognition in Video

This repository provides a MATLAB-based framework for automated human behavior and action recognition in videos. It includes the full pipeline for local motion pattern (LMP) feature extraction, dictionary learning, and classification using sparse representation methods.

## Project Structure

- **`Main Codes/`**: Main scripts for training, feature extraction, classification, and cross-validation.
- **`Algorithms of Classification/`**: Classification methods such as `RSR`, `SRCI`, and `SRCO`.
- **`Run with LMP/`**: LMP-based implementation files, including keypoint detection and descriptor generation.
- **`Building dataset/`**: Scripts for preparing benchmark datasets such as UCF Sports and Weizmann.

## Pipeline Overview

The recognition pipeline works as follows:

1. **Feature Extraction**  
   Videos are processed using **Local Motion Patterns (LMP)**.  
   The system detects local keypoints and builds descriptors using functions such as:
   - `lmpDetect`
   - `lmpDes`
   - `kp_harris`

2. **Multi-Scale Analysis**  
   The method uses multiple temporal scales:
   - `N_sq = [8, 10, 12]`

   and a spatial window size:
   - `w = 24`

3. **Dimensionality Reduction**  
   The extracted descriptors are projected into a lower-dimensional space using a matrix `d_mat`.

4. **Dictionary Learning**  
   Class-specific dictionaries are learned from training data using:
   - `elham_DicLearning.m`

5. **Classification**  
   The learned representation is classified using:
   - `RSR.m`

## Quick Start

### 1. Prepare the Dataset
Use the scripts in `Building dataset/` to format and organize your dataset.

### 2. Train the Model
Run:
```matlab
elham_DicLearning
```
This will generate the learned dictionaries and other required training outputs.

### 3. Evaluate the Model
Run:
```matlab
elham_Classification
```
or use the leave-one-out evaluation script:
```matlab
elham_Loocv
```
## Main Files
```text
Main Codes/elham_MakeDes.m — builds descriptors/features
Main Codes/elham_DicLearning.m — performs dictionary learning
Main Codes/elham_Classification.m — performs classification
Main Codes/elham_Loocv.m — leave-one-out cross-validation
Algorithms of Classification/RSR.m — sparse representation classifier
Algorithms of Classification/SRCI.m — sparse representation classifier variant
Algorithms of Classification/SRCO.m — sparse representation classifier variant
```
## Dependencies
```text
MATLAB
Image Processing Toolbox
Signal Processing Toolbox
Any additional toolboxes required by the LMP functions
```
## Citation
If you use this code in your research, please cite the original project.
