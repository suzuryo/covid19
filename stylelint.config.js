module.exports = {
  extends: ['stylelint-config-standard', 'stylelint-config-prettier'],
  plugins: ['stylelint-scss'],
  rules: {
    'at-rule-empty-line-before': null,
    'at-rule-no-unknown': null,
    'rule-empty-line-before': null,
    'scss/at-rule-no-unknown': true,
  },
}
