1. Run `elm bump` to update the version.
2. Update changelog with new version.
3. Commit with message `Release <version>`.
4. Push branch to GitHub with `git push`.
5. Create and merge the PR.
6. Pull the new `master`.
7. Create a version tag with `git tag <version>`.
8. Push tag to GitHub with `git push origin <version>`.
9. Run `elm publish`.