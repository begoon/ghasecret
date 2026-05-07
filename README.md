# ghasecret

A GitHub Action that triple-base64-encodes secret values so they can be recovered from workflow logs.

## Why

GitHub Actions automatically masks `secrets.*` values in logs as `***`, and also masks their single-base64 form. Sometimes — during incident response, key migration, or vendor handoffs — the owner of a repo legitimately needs to read a secret value out of GitHub.

Triple-base64 is the smallest reliable obfuscation that bypasses the masker: the resulting blob shares no common substring with the raw secret or its single-base64 form, so the log filter does not match it. The blob can be pasted into a local terminal and decoded with three `base64 -d` invocations to recover the original.

## Usage

### A single secret

```yaml
- uses: begoon/ghasecret@v1
  with:
    secret: ${{ secrets.MY_SECRET }}
```

### Multiple secrets

Each line is `NAME=VALUE`. The `NAME` is used as the label in the printed output:

```yaml
- uses: begoon/ghasecret@v1
  with:
    secrets: |
      MY_SECRET=${{ secrets.MY_SECRET }}
      OTHER=${{ secrets.OTHER }}
      API_TOKEN=${{ secrets.API_TOKEN }}
```

## Output

For each secret the action prints a collapsible group like:

```text
::group::MY_SECRET
value:  WkVkb2NHTjVNWEJqZVRGb1RGY3hNVmt5...
decode: echo 'WkVkb2NHTjVNWEJqZVRGb1RGY3hNVmt5...' | base64 -d | base64 -d | base64 -d
::endgroup::
```

Copy the `decode:` line into your terminal (Linux or macOS — both BSD and GNU `base64` accept `-d`) and the original secret is printed to stdout.

## Security

Anyone with read access to the workflow logs can decode these values. Use this only:

- on a private repo, or a repo you fully control
- in a workflow you trust (do not run on untrusted PRs)
- as a one-off — rotate the secret afterwards

## License

MIT
