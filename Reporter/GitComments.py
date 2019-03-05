from git import Repo
import sys

#gitURI = sys.argv[1]
selectedBranch = "develop"
repo = Repo("C:\\temp\\repo\hsdp-bti")
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
    print("Now checkedout: " + repo.active_branch.name)
