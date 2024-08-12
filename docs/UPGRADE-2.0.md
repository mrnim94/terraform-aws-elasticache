## Upgrade from v1.x to v2.x

Please consult the `README.md` directory for reference example configurations. If you find a bug, please open an issue with a supporting configuration to reproduce.

### ⚠️ Upcoming Changes Planned in v2.0 ⚠️

To give users advanced notice and provide some future direction for this module, these are the following changes we will be looking to make in the next major release of this module:

1.  `enable` the `cluster_mode`  via variable, you must also declare cluster-enable: yes in Parameter Group. Refer to: [https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/modify-cluster-mode.html](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/modify-cluster-mode.html)
2.  Instead of hard code Parameter Group in the module as before, you will declare it in the parameters variable.
3.  Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false"

## Additional changes

---

### Added

*   Add feature `cluster_mode enable` and parameter group for MSK

### Variable and output changes

1.  Added variables
    *   `apply_immediately`
    *   `cluster_mode`
    *   `parameters`