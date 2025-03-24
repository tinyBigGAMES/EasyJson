# ![EasyJson](media/easyjson.png)  
[![Chat on Discord](https://img.shields.io/discord/754884471324672040?style=for-the-badge)](https://discord.gg/tPWjMwK) [![Follow on Bluesky](https://img.shields.io/badge/Bluesky-tinyBigGAMES-blue?style=for-the-badge&logo=bluesky)](https://bsky.app/profile/tinybiggames.com)  

## 🚀 Overview

**`TEasyJson`** is a powerful and intuitive Delphi class that simplifies JSON manipulation. Designed with a fluent interface, it enables developers to seamlessly create, modify, and traverse JSON objects and arrays using method chaining. Whether handling simple key-value pairs or deeply nested structures, `TEasyJson` ensures efficiency, readability, and flexibility.

## ✨ Features

- 🚀 Fluent interface for effortless JSON manipulation  
- 📂 Supports both JSON objects and arrays  
- 🔗 Chainable methods for concise and readable code  
- 🏗️ Easily constructs and modifies nested JSON structures  
- 🎨 Provides formatted JSON output for better readability  
- ⚡ Optimized for performance and efficiency  

## 📥 Installation

Getting started with `TEasyJson` is quick and easy:

1. **Copy** `TEasyJson.pas` into your project.  
2. **Add** `TEasyJson` to your `uses` clause.  
3. **Start Coding!** Enjoy simplified JSON handling with method chaining.  

## 🛠️ Usage

### 🔹 Creating a JSON Object

```delphi
var EJ: TEasyJson;
begin
  EJ := TEasyJson.Create;
  EJ.Put('name', 'Alice')
    .Put('age', 25)
    .AddArray('hobbies')
    .Put(0, 'Reading')
    .Put(1, 'Cycling');

  WriteLn(EJ.Format());
end;
```

#### 🏷️ Output:
```json
{
  "name": "Alice",
  "age": 25,
  "hobbies": [
    "Reading",
    "Cycling"
  ]
}
```

### 🔹 Creating a JSON Object from a String
```delphi
var EJ: TEasyJson;
begin
  EJ := TEasyJson.Create('{"name":"John","age":30}');
  WriteLn(EJ.Format());
end;
```

### 🔹 Adding and Modifying Values
```delphi
EJ.Put('email', 'alice@example.com');
EJ.Put('age', 26); // Updates existing key
```

### 🔹 Working with JSON Arrays
```delphi
var EJ: TEasyJson;
begin
  EJ := TEasyJson.Create;
  EJ.AddArray('numbers')
    .Put(0, 10)
    .Put(1, 20)
    .Put(2, 30);

  WriteLn(EJ.Format());
end;
```

### 🔹 Nesting JSON Objects
```delphi
EJ.AddObject('address',
  function(E: TEasyJson): TEasyJson
  begin
    Result := E.Put('city', 'New York')
               .Put('zip', '10001');
  end);
```

### 🔹 Accessing JSON Elements
```delphi
WriteLn(EJ['name'].AsString);  // Alice
WriteLn(EJ['age'].AsInteger);  // 26
WriteLn(EJ['hobbies'][1].AsString);  // Cycling
```

## 📖 API Reference

The `TEasyJson` class provides a robust set of methods and properties for seamless JSON manipulation.

### 🔹 Constructors
- `Create()` – Creates an empty JSON object.  
- `Create(const AJson: string)` – Parses a JSON string.  
- `Create(const AJsonValue: TJSONValue)` – Wraps an existing JSON value.  

### 🔹 Methods
- `Put(AKey: string; AValue: Variant): TEasyJson` – Adds or updates a key.  
- `Put(AIndex: Integer; AValue: Variant): TEasyJson` – Sets an array element.  
- `Add(AKey: string; AValue: Variant): TEasyJson` – Adds a new key-value pair.  
- `AddArray(AKey: string): TEasyJson` – Adds an empty array.  
- `AddObject(AKey: string; AFunc: TFunc<TEasyJson, TEasyJson>): TEasyJson` – Adds a nested object.  
- `ToString(): string` – Returns a compact JSON string.  
- `Format(): string` – Returns formatted JSON.  
- `Count(): Integer` – Returns the number of elements.  
- `AsString(): string` – Converts a JSON value to a string.  
- `AsInt32r(): Int32` – Converts a JSON value to an int32.  
- `AsFloat(): Double` – Converts a JSON value to a float.  
- `AsBoolean(): Boolean` – Converts a JSON value to a boolean.  

### 🔹 Properties
- `Items[AKeyOrIndex: Variant]: TEasyJson` – Accesses elements by key or index.  

See `EasyJson.pas` for the full documented API.

## 💬 Support & Resources

- 🐞 **Report Issues:** [GitHub Issue Tracker](https://github.com/tinyBigGAMES/EasyJson/issues)  
- 💬 **Join the Community:** [Forum](https://github.com/tinyBigGAMES/EasyJson/discussions) | [Discord](https://discord.gg/tPWjMwK)  
- 📚 **Learn Delphi:** [Learn Delphi](https://learndelphi.org)  

## 🤝 Contributing

We welcome contributions to **EasyJson**! 🚀  

### 💡 Ways to Contribute:
- 🐛 **Report Bugs** – Help improve `TEasyJson` by submitting issues.  
- ✨ **Suggest Features** – Share ideas to enhance its functionality.  
- 🔧 **Submit Pull Requests** – Improve the codebase and add features.  

### 🏆 Contributors

<a href="https://github.com/tinyBigGAMES/EasyJson/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=tinyBigGAMES/EasyJson&max=250&columns=10&anon=1" />
</a>

## 📜 License

**EasyJson** is distributed under the **BSD-3-Clause License**, allowing redistribution and modification in both source and binary forms. 
See the [LICENSE](https://github.com/tinyBigGAMES/EasyJson?tab=BSD-3-Clause-1-ov-file#BSD-3-Clause-1-ov-file) for details.

## 💖 Support & Sponsorship

Your support keeps **EasyJson** evolving! If you find this library useful, please consider [sponsoring the project](https://github.com/sponsors/tinyBigGAMES). Every contribution helps drive future enhancements and innovations.

### Other ways to support:
- ⭐ **Star the repo** – Show your appreciation.  
- 📢 **Share with your network** – Spread the word.  
- 🐛 **Report bugs** – Help improve `TEasyJson`.  
- 🔧 **Submit fixes** – Contribute by fixing issues.  
- 💡 **Suggest features** – Help shape its future.  

🚀 Every contribution makes a difference – thank you for being part of the journey!  
  
---

🔥 *EasyJson – Effortless JSON Handling for Delphi with Fluent Simplicity.*

<p align="center">
  <img src="media/delphi.png" alt="Delphi">
</p>
<h5 align="center">Made with ❤️ in Delphi</h5>

