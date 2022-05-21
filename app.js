const submitButton = document.getElementById("form-submit");

let formData = {};

document.addEventListener("input", ({ target }) => {
  const validInputs = ["name", "email", "phone"];

  if (validInputs.includes(target.name)) {
    formData = { ...formData, [target.name]: target.value };
  }
});

submitButton.addEventListener("submit", async (e) => {
  e.preventDefault();

  const url = "https://hooks.zapier.com/hooks/catch/12559542/bfm80ew";

  const response = await fetch(url, {
    method: "POST",
    body: JSON.stringify({ formData }),
  });

  //   console.log("response", response);
});
