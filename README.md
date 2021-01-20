# Stops People merging Pre-Release Nuget References

The Problem? Sometimes Engineers add references to pre-release packages (e.g. a package that has a "-" suffix follow by a string seen in the Image below), in general pre-release packages shouldn't be trusted, hence the name. We don't assume Engineers have the wrong intent though, most of the time we found when this occurred in reality that someone just forgot to rollback a change they were testing with and it was missed in the code review.

![image](https://user-images.githubusercontent.com/15168410/105111235-0b6a4a00-5af3-11eb-8b68-9d9a41bec7ff.png)

Explodes the build if any references in csproj files to one or more Pre-Release Nuget packages with details of which csproj and what packages and versions.

## Inputs

### `solution-file-full-path`

**Required** The full path to the solution file for your application.

## Example usage

```yaml
jobs:    
  nuget-alpha:
    name: Nuget PreRelease package check
    steps:
      - uses: actions/checkout@v2    
      - uses: agoda-com/ga-nuget-alpha-detection@v1
        with:
          solution-file-full-path: 'src/mySolution.sln'
```

## Thanks

Thanks to [@jenol](https://github.com/jenol) who original help out with this code when it was in Teamcity
