Linter-Ruby-Reek = LRR
=========================

## LRR: A neat Linter for Ruby files.

¶¶ This plugin *seriously* Works fine with reek! ¶¶

Using *Reek* Ruby gem: a tool that examines Ruby classes, modules and methods.

∑ ∑ Reports any code SMELLS it detects. ∑ ∑

We use The interface of the beautifull [Linter](https://github.com/AtomLinter/Linter)
to prived the neet features of [Reek](https://github.com/troessner/reek).

## Installation
### dependencies:
1 - Linter package.
  To install Linter: [Linter](https://github.com/AtomLinter/Linter).

2 - Reek gem.
  Make ensure that `reek` is installed on your system.

  == To install `reek`, do the following:
   ```
   gem install reek
   ```

### Executable Path

Add reek path:
- Up here in the **settings panel**

**or**

- here:
**~/.atom/config.cson** (choose Open Your Config in Atom menu).

```
'linter-reek':
  reekExecutablePath: "/path/to/your/reek/here"
```
- Run **`which reek`** to find the path **or** run **`rbenv which reek`** for rbenv users.
- If you don't, **`reek`** will be the default settings.

**NOTE - 1**:
- Open atom from the terminal if you don't see the linter working, it's Atom
  doesn't see the path sometimes unless opened from the terminal.
  **I'm working to find the best way to avoid this issues**
  **BUT**, maybe you should add the Path in **~/.atom/config.cson** in that order:
  1. "linter-ruby":
  2. "linter-reek":
  3. linter:
  I have to test that and see...

**NOTE - 2**:
- Please, note that reek only provides line numbers for errors, for now. So, columns are set
to 1 as default.


### Enjoy it! ;)

Thank you!
@ahmadSeleem
