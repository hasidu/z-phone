export function searchByKeyValueContains(data, key, value) {
  if (value == "") {
    return data;
  }

  return data.filter(
    (data) => data[key] && data[key].toLowerCase().includes(value.toLowerCase())
  );
}

export function currencyFormat(amount) {
  return new Intl.NumberFormat("en-US", {
    style: "decimal",
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
}

export function isNumeric(str) {
  // Regular expression to check if the string contains only digits
  const regex = /[^0-9]/;
  return regex.test(str);
}

export function isNonAlphaNumeric(str) {
  // Regular expression to test for non-alphanumeric characters
  const regex = /[^a-zA-Z0-9]/;
  return regex.test(str);
}
