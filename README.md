# Stops People merging Pre-Release Nuget References

Explodes the build if any references to Pre-Release nuget packages.


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