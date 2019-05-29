# `exy` – fast, reliable CI builds for Xcode workspaces
```
exy test --cache /path/to/cache MyApp.xcodeworkspace MyScheme \
  -- -destination "name=iPhone X" -sdk iphonesimulator \
  | tee xcodebuild.log \
  | xcpretty
```

## Overview
Xcode’s build system has a few building blocks:

- _product_: something that’s built
- _target_: instructions for building a _product_
- _scheme_: a collection of _targets_
- _project_: a collection of _targets_ and _schemes_
- _workspace_: a collection of _projects_ and _schemes_

These can be configured in a number of ways. But one arrangement is particularly powerful: a workspace of interdependent projects. By building through a workspace, you can choose between building all targets at once or building them individually.

`exy` uses `xcodebuild` to build the projects in a workspace individually, making the products available to the projects that depend on them. But it caches products to avoid recompiling unchanged targets. This enables fast, reliable builds on CI—most of the speed of dirty builds with the reliability of clean builds.

More details are available [below](#how-it-works).

## Usage
`exy` can either (1) build a whole workspace at once or (2) build each target separately. The latter may perform better on sophisticated CI solutions that support caching and parallel build stages.

### Whole Workspace Builds
`exy build` can build an entire scheme in a workspace. `exy test` can test an entire scheme and build anything that’s missing. That means you can either call `exy build` and then `exy test` if you want multiple stages or choose to only call `exy test` if you don’t care.

The calls to `exy` are straightforward:

```
exy build --cache <cache-dir> <workspace> <scheme> [-- [xcodebuild arguments]]

exy test --cache <cache-dir> <workspace> <scheme> [-- [xcodebuild arguments]]
``` 

In the normal case, the output will be the unaltered output from `xcodebuild`. But if an error occurs, it will also be printed.

### Parallel Builds
Building in parallel is more complicated. The work that’s done by `exy build` and `exy test` is split into multiple stages; these stages must be understood and reassembled correctly.

#### 1. Generate the Build Graph
The initial stage is to generate the build graph—creating the list of schemes to build and the order in which they must be built. This can be used to parallelize the work across multiple machines.

`exy graph <workspace> <scheme>` will output a simple YAML document listing all the dependencies of each scheme.


```
» exy graph Example.xcworkspace ExampleApp
Framework1:
Framework2:
  - Framework1
Framework3:
  - Framework1
  - Framework2
Framework4:
  - Framework1
ExampleApp:
  - Framework1
  - Framework2
  - Framework3
  - Framework4
```

Use this to split your CI into multiple jobs.

You may need to create your build config before the CI job begins for your branch. If that’s the case, you should add a test to CI that verifies that this config is up to date.

#### 2. Restore a Cached Version
The speedups come from using cached products for some or all of the schemes. Use `exy key <workspace> <scheme>` to calculate a cache key that can be used to locate built products for a given scheme.

If you’re using a system with built-in caching—like CircleCI—then you may want to save this key to a file on disk.

If you’re using an ordinary file system as a cache, you can use `exy restore <key> <cache-dir> <derived-data-dir>` to restore those files to the derived data directory. If the cache doesn’t contain the key, then `exy restore` will return a failed status; you can use this to decide whether to build and test the scheme.

You can also `exy restore <workspace> <scheme> <cache-dir>` calculate the cache key and restore in a single command.

You also need to restore the cached products for all of your dependencies.

#### 2. Build the Scheme
Actually building the scheme is easy:

```
exy build <workspace> <scheme> [-- [xcodebuild arguments]]
```

After building the scheme, you’ll need to save the products for the cache using the key from `exy key <workspace> <scheme>`.

You can get a YAML document with the list of products to save using `exy products <workspace> <scheme>`:

```
» exy products Example.xcworkspace Framework1
- path/to/Framework1.framework
- path/to/Framework1.dSYM
```

And then you can save them using `exy save <key> <product> ... <cache-dir>`.

Or you can use `exy save <workspace> <scheme> <cache-dir>` to calculate the key and save the products all in one go.

#### 3. Test the Scheme
The scheme can be tested with `exy test`:

```
exy test <workspace> <scheme> [-- [xcodebuild arguments]]
```

You’ll need to restore the cached products for the scheme or build the scheme before you can run the tests.

### Miscellaneous Caching
`exy`’s caching can also be used for other built products. Create a key for a set of inputs using `exy key [input files]`. Then use `exy save` and `exy restore` to copy the cache items to the correct location.

## How It Works
The secret sauce of `exy` is calculating the build graph and calculating reliable cache keys.

### The Build Graph
The build graph is built by reading the Xcode workspace and project files. Starting with the initial scheme, `exy` reads through projects to determine which frameworks they require and which projects provide those frameworks. This essentially duplicates Xcode’s _implicit dependencies_ feature.

### Cache Keys
Cache keys are calculated from the SHAs of all the inputs to a given scheme. This is essentially equivalent to the way that Git uses SHAs to store trees and files. If the SHAs of all the inputs are unchanged, then the cache key for the scheme is also unchanged.

`exy` can be conservative when calculating cache keys for performance reasons or to prevent false equivalencies.

## License
`exy` is available under the MIT license.

