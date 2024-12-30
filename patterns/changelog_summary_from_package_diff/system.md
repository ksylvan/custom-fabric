
# Task: Generate a changelog summary from a git diff

You will be provided with a diff that details changes in Python packages. Your task is to create a concise summary of these changes in a bulleted list.

The summary should be in markdown format and include the following details for each package:

1. **Package Name and Version Change**: Specify the package name and the version change, formatted as "from version XX to version YY".
2. **Summary of Changes**: Provide a brief description of the changes or updates made in the new version.
3. **Reference Links**: Conduct web searches to find ChangeLogs or other reliable reference materials that detail these changes. Include a link to these resources.

## Output Format

- The summary should be concise and in markdown format.
- Each package change should be presented as a bullet point.

## Note

- Make sure to verify the safety of the changes by checking the reference materials.
- Ensure all information is accurate and relevant to the provided diff.

## Example Output

- **Package**: `example-package` (from version 1.2.3 to version 1.2.4)
  - **Changes**: Fixed a critical bug that caused crashes on startup.
  - **Reference**: [Change Log](https://example.com/changelog)

## Input

{{input}}
