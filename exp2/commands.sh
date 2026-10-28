#!/bin/bash

# ============================================
# EXPERIMENT 2: Important Git and GitHub Commands
# ============================================

# --------------------------------------------
# 1. Basic Commands
# --------------------------------------------

# Initialize a new local Git repository
git init

# Clone an existing remote repository from GitHub
# Replace <repository-url> with your repository link
# git clone <repository-url>

# Check the status of the working directory and staged files
git status

# Stage all modified and new files for commit
git add .

# Record staged changes with a descriptive message
git commit -m "Commit message"

# Show full commit history with author, date, and commit hashes
git log

# --------------------------------------------
# 2. Branch Management
# --------------------------------------------

# Create a new branch
git branch exp2-practice

# Switch to the new branch
git switch exp2-practice

# List all local branches
git branch

# Switch back to main
git switch main

# --------------------------------------------
# 3. GitHub Remote Commands
# --------------------------------------------

# Display configured remote repositories
git remote -v

# Push the current branch to GitHub
git push origin main

# Download and integrate changes from GitHub
git pull origin main

# --------------------------------------------
# 4. Additional Commands
# --------------------------------------------

# Show a summary of recent commits
git log --oneline

# Show differences in modified files
git diff

# Show staged changes
git diff --staged