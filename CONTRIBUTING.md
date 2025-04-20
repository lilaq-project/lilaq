# Contributing to Lilaq

Thank you for your interest in contributing to Lilaq! This document outlines the guidelines for contributing to the project.

---

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [How to Contribute](#how-to-contribute)
    - [Reporting Issues](#reporting-issues)
    - [Suggesting Enhancements](#suggesting-enhancements)
    - [Submitting Pull Requests](#submitting-pull-requests)
3. [Development Workflow](#development-workflow)
4. [Testing](#testing)
5. [Documentation](#documentation)
6. [Code Style](#code-style)
7. [License](#license)

---

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/). By participating, you are expected to uphold this code. Please report unacceptable behavior to the repository maintainers.

---

## How to Contribute

### Reporting Issues

If you encounter a bug, have a feature request, or notice something that can be improved, please [open an issue](https://github.com/lilaq-project/lilaq/issues). When reporting an issue, include:

- A clear and descriptive title.
- Steps to reproduce the issue.
- Expected and actual behavior.
- Relevant screenshots or code snippets, if applicable.

### Suggesting Enhancements

We welcome suggestions for new features or improvements! To suggest an enhancement:

1. Check the [issues page](https://github.com/lilaq-project/lilaq/issues) to ensure your idea hasn’t already been proposed.
2. Open a new issue and include:
   - A clear and descriptive title.
   - A detailed explanation of the enhancement.
   - Any relevant examples, use cases, or benefits of the proposed change.

### Submitting Pull Requests

We welcome contributions in the form of pull requests (PRs). To ensure a smooth process, please follow these best practices:

1. **Discuss First**: Before starting work on a new feature or significant change, open an issue to discuss your idea with the maintainers and community. This helps ensure alignment, avoids duplicate efforts, and allows maintainers to provide guidance or feedback.
2. **Fork the Repository**: Create a fork of the repository in your GitHub account.
3. **Create a Branch**: Create a new branch for your changes:
   ```sh
   git checkout -b feature/your-feature-name
   ```
4. **Write Clear Commits**: Make your changes and commit them with clear and concise commit messages.
5. **Test Your Changes**: Ensure all tests pass and write new tests for any added functionality. Document your test cases briefly in the PR description to help reviewers understand your approach.
6. **Push Your Branch**: Push your branch to your fork:
   ```sh
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request**: Open a pull request against the `main` branch of the repository. Include a detailed description of your changes and reference any related issues.

---

## Testing

All contributions must pass the test suite before being merged. Lilaq uses [tytanic](https://github.com/tingerrr/tytanic) for managing tests. 
To run tests locally, [install the latest version of tytanic](https://tingerrr.github.io/tytanic/quickstart/install.html) and use the following command at the root level of the repository:
```sh
tt run
```

If you add new features, ensure you [write corresponding tests](https://tingerrr.github.io/tytanic/guides/tests.html). Tests should be clear and in particular cover edge cases. Document your test cases briefly in the PR description to help reviewers understand your approach. If you need to update test reference images, use the GitHub workflow defined in [`.github/workflows/update_test_refs.yml`](.github/workflows/update_test_refs.yml).

---

## Documentation

The documentation for Lilaq is hosted at [https://lilaq.org](https://lilaq.org). If you make changes to the library, ensure the documentation is updated accordingly. Documentation of individual functions should be written as doc-comments in the code while tutorials and examples can be contributed to https://github.com/lilaq-project/lilaq-project.github.io. 

---

## Code Style

To maintain consistency across the codebase, please adhere to the following code style guidelines:

- **Formatting**: Use consistent indentation and spacing. Use **2 spaces** for indentation in all files, including `.typ` files.
- **Naming**: Use descriptive and meaningful names for variables, functions, and parameters. For names like function and parameter names that are part of the public API, try to be consistent with the Typst standard library. Use `kebab-case` for all variable and function names. 
- **Comments**: Write clear and concise comments to explain the purpose of complex logic or non-obvious code. Use `///` for documentation comments and `//` for inline comments.
- **Documentation**: Lilaq uses the [tidy](https://github.com/Mc-Zen/tidy) documentation style for Typst doc-comments. 
- **Line Length**: Keep lines under 80 characters where possible to improve readability.
- **Imports**: Group related imports together and avoid unused imports. Use relative paths for internal modules.
- **Testing**: Write tests for new features or bug fixes. Ensure tests are clear and cover edge cases. The [tytanic test writing guide](https://tingerrr.github.io/tytanic/guides/tests.html) is a useful resource for starting to write tests for Typst code. Try to keep reference images small and when possible, use assertions instead. 

---

## License

By contributing to this repository, you agree that your contributions will be licensed under the [MIT License](LICENSE).

---

Thank you for contributing to Lilaq! Your efforts make this project better for everyone.