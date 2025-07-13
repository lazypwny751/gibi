package download

import (
	git "github.com/go-git/go-git/v5"
)

// CloneRepository clones a Git repository to the specified directory.
// It returns an error if the cloning process fails.
func CloneRepository(repoURL, dir string) error {
	_, err := git.PlainClone(dir, false, &git.CloneOptions{
		URL: repoURL,
	})
	if err != nil {
		return err
	}
	return nil
}

// PullLatestChanges pulls the latest changes from the remote repository.
// It returns an error if the pull operation fails.
func PullLatestChanges(repo *git.Repository) error {
	worktree, err := repo.Worktree()
	if err != nil {
		return err
	}
	err = worktree.Pull(&git.PullOptions{})
	if err != nil && err != git.NoErrAlreadyUpToDate {
		return err
	}
	return nil
}