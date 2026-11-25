# AppSignal APM for Ruby - Renuo version

Read the [original README](https://github.com/appsignal/appsignal-ruby) for the details about this gem.
Here we only list the differences with the original gem.

## Sampling

You can sample the transactions sent to AppSignal with the `sampling_rate` option. Set it like any other option, in
`config/appsignal.yml`:

```yaml
production:
  sampling_rate: 0.05
```

or with the `APPSIGNAL_SAMPLING_RATE` environment variable, which wins over the file.

- `1.0`, the default, records every transaction.
- `0.5` records half of them.
- `0.01` records 1% of them.

Transactions with an error are always recorded.

> ⚠️ This changes the statistics you see on AppSignal, since most transactions are not sent.
