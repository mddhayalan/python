from git import Repo
import git
import sys
import os
import shutil

workingDir = "C:\\temp\\repo\\"
gitURI =  input("Enter the Git Url: ")
archiveName = gitURI.split('/')[-1]
fullWorkingDir = os.path.join(workingDir, archiveName)
if (os.path.isdir(fullWorkingDir)):# TODO: Instead of Deleting filder check if the url is same, if same do a pull instead
    #shutil.rmtree(fullWorkingDir, ignore_errors=True)
    repo = Repo(fullWorkingDir)
else:
    repo = git.Repo.clone_from(gitURI, os.path.join(workingDir, archiveName))
selectedBranch = "develop"
active_branch = repo.active_branch.name
branchList = repo.git.branch('-a').split('\n')
print("The following are the branches available :")
for r in branchList:
    r_trimmed = r.strip(' ')
    if (r_trimmed.startswith("remotes")):
        r_trimmed = r_trimmed.replace("remotes/origin/", "")
        print(r_trimmed)
selectedBranch  = input("Enter the branch name: ")
if active_branch == selectedBranch:
    print("No switch branch required, as the repo is in branch: "+active_branch)
else:
    repo.git.checkout(selectedBranch)
    print("Now checked out: " + repo.active_branch.name)
commitHash = [] # This list contains all the commits in descending order, we can use this to populate both the from and to revisions combobox
commitDict = dict()

for c in repo.iter_commits():
    commitDict[c.hexsha]=c
    commitHash.append(c.hexsha)
    #print("{0} -> {1} --> {2}".format(c.hexsha, c.author.name, c.summary))
# TODO: once the To revision is selected we can create a sublist just to list revision from preceding revision till the end.
toCommit = input("Enter the To revision: ")
fromCommit= input("Enter the From revision: ")
toIndex = commitHash.index(toCommit)
fromIndex = commitHash.index(fromCommit)
deltaCommits = commitHash[fromIndex:toIndex]
deltaChanges = dict()
for commi in deltaCommits:
    #deltaChanges[commi] = commitDict[commi]
    changes = commitDict[commi]
    print("Commit ID:{0}---{1}\n{2}\n------------------------------------------------------------".format(changes.hexsha, changes.author.name, changes.message))