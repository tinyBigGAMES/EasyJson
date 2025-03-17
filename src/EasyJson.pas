﻿{===============================================================================
   ___                 _
  | __|__ _ ____  _ _ | |___ ___ _ _ ™
  | _|/ _` (_-< || | || (_-</ _ \ ' \
  |___\__,_/__/\_, |\__//__/\___/_||_|
               |__/
      Effortless JSON Handling for
     Delphi with Fluent Simplicity.

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/EasyJson

 See LICENSE file for license information
===============================================================================}

unit EasyJson;

interface

uses
  System.SysUtils,
  System.Variants,
  System.JSON,
  System.Generics.Defaults,
  System.Generics.Collections;

type

  /// <summary>
  ///   Specifies whether a <c>TEasyJson</c> instance owns the JSON value
  ///   it is handling or merely holds a reference to it.
  /// </summary>
  TEjValueOwnership = (ejOwned, ejReference);

  /// <summary>
  ///   <c>TEasyJson</c> is a fluent interface class designed to simplify
  ///   working with JSON objects and arrays in Delphi.
  /// </summary>
  /// <remarks>
  ///   This class provides an intuitive way to manipulate JSON structures,
  ///   allowing dynamic creation, modification, and retrieval of JSON data
  ///   using method chaining. It supports both JSON objects and arrays,
  ///   making it easy to construct complex JSON documents with minimal code.
  /// </remarks>
  /// <para>
  ///   Key Features:
  ///   <list type="bullet">
  ///     <item>Fluent API for intuitive JSON construction.</item>
  ///     <item>Supports nested objects and arrays.</item>
  ///     <item>Seamless conversion of JSON values to native Delphi types.</item>
  ///     <item>Formatted and compact JSON serialization.</item>
  ///   </list>
  /// </para>
  /// <example>
  ///   Creating a JSON object with nested properties and arrays:
  ///   <code>
  ///   var EJ: TEasyJson;
  ///   begin
  ///     EJ := TEasyJson.Create;
  ///     EJ.Set('name', 'Alice')
  ///       .Set('age', 25)
  ///       .AddArray('hobbies')
  ///         .Set(0, 'Reading')
  ///         .Set(1, 'Cycling')
  ///       .AddObject('address')
  ///         .Set('city', 'New York')
  ///         .Set('zipcode', '10001');
  ///
  ///     ShowMessage(EJ.Format);
  ///   end;
  ///   </code>
  ///   Output:
  ///   <code>
  ///   {
  ///     "name": "Alice",
  ///     "age": 25,
  ///     "hobbies": [
  ///       "Reading",
  ///       "Cycling"
  ///     ],
  ///     "address": {
  ///       "city": "New York",
  ///       "zipcode": "10001"
  ///     }
  ///   }
  ///   </code>
  /// </example>
  TEasyJson = class
  private
    FJsonValue: TJSONValue;
    FParent: TEasyJson;
    FOwnership: TejValueOwnership;

    function AsObject(): TJSONObject;
    function AsArray(): TJSONArray;
    //function AsJSONValue(): TJSONValue;
    function GetValue(const AKeyOrIndex: Variant): TEasyJson;
    function CreateJsonValue(const AValue: Variant): TJSONValue;

    // Helper to safely add a new pair to a JSON object
    procedure SafeAddPair(AObj: TJSONObject; const AName: string; AValue: TJSONValue);

    // Helper to safely get/create a JSON array
    function GetOrCreateArray(AArray: TJSONArray; AIndex: Integer): TJSONArray;
  public
    /// <summary>
    ///   Initializes a new instance of the <c>TEasyJson</c> class as an empty JSON object.
    /// </summary>
    /// <remarks>
    ///   - This constructor creates an empty JSON object (<c>{}</c>).
    ///   - Use this when you need to build a JSON structure dynamically.
    /// </remarks>
    /// <example>
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.Set('name', 'Alice').Set('age', 25);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "name": "Alice",
    ///     "age": 25
    ///   }
    ///   </code>
    /// </example>
    constructor Create(); overload;

    /// <summary>
    ///   Initializes a new instance of the <c>TEasyJson</c> class from a JSON string.
    /// </summary>
    /// <param name="AJson">
    ///   A valid JSON-formatted string used to populate this instance.
    /// </param>
    /// <remarks>
    ///   - If the JSON string is invalid, behavior depends on error handling (it may raise an exception or initialize an empty object).
    ///   - The instance takes ownership of the parsed JSON structure.
    /// </remarks>
    /// <example>
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create('{"name":"Alice","age":25}');
    ///     ShowMessage(EJ['name'].AsString); // Outputs: Alice
    ///   end;
    ///   </code>
    /// </example>
    constructor Create(const AJson: string); overload;

    /// <summary>
    ///   Initializes a new instance of the <c>TEasyJson</c> class from an existing <c>TJSONValue</c>.
    /// </summary>
    /// <param name="AJsonValue">
    ///   The <c>TJSONValue</c> object that this instance will wrap.
    /// </param>
    /// <param name="AOwnership">
    ///   Defines whether <c>TEasyJson</c> owns the JSON value (<c>ejOwned</c>) or only references it (<c>ejReference</c>).
    ///   Default is <c>ejOwned</c>.
    /// </param>
    /// <remarks>
    ///   - If <c>AOwnership</c> is set to <c>ejOwned</c>, <c>TEasyJson</c> takes responsibility for freeing <c>AJsonValue</c>.
    ///   - If <c>AOwnership</c> is set to <c>ejReference</c>, the caller remains responsible for managing the lifetime of <c>AJsonValue</c>.
    /// </remarks>
    /// <example>
    ///   Example with ownership:
    ///   <code>
    ///   var JSONValue: TJSONObject;
    ///       EJ: TEasyJson;
    ///   begin
    ///     JSONValue := TJSONObject.Create;
    ///     EJ := TEasyJson.Create(JSONValue, ejOwned);
    ///     EJ.Set('name', 'Bob');
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///
    ///   Example with reference:
    ///   <code>
    ///   var JSONValue: TJSONObject;
    ///       EJ: TEasyJson;
    ///   begin
    ///     JSONValue := TJSONObject.Create;
    ///     EJ := TEasyJson.Create(JSONValue, ejReference);
    ///     EJ.Set('name', 'Charlie');
    ///     ShowMessage(JSONValue.ToString); // JSONValue still exists after EJ is freed
    ///     EJ.Free;
    ///     JSONValue.Free; // Caller must free the referenced value
    ///   end;
    ///   </code>
    /// </example>
    constructor Create(const AJsonValue: TJSONValue; AOwnership: TejValueOwnership = ejOwned); overload;

    /// <summary>
    ///   Initializes a new instance of the <c>TEasyJson</c> class from an existing <c>TJSONValue</c>,
    ///   associating it with a parent <c>TEasyJson</c> instance.
    /// </summary>
    /// <param name="AJsonValue">
    ///   The <c>TJSONValue</c> object that this instance will wrap.
    /// </param>
    /// <param name="AParent">
    ///   The parent <c>TEasyJson</c> instance that owns or manages <c>AJsonValue</c>.
    /// </param>
    /// <param name="AOwnership">
    ///   Defines whether <c>TEasyJson</c> owns the JSON value (<c>ejOwned</c>) or only references it (<c>ejReference</c>).
    ///   Default is <c>ejReference</c>.
    /// </param>
    /// <remarks>
    ///   - This constructor is typically used when a child <c>TEasyJson</c> instance needs to be managed
    ///     within a larger JSON structure.
    ///   - If <c>AOwnership</c> is set to <c>ejReference</c>, <c>AParent</c> is responsible for managing the JSON value.
    /// </remarks>
    /// <example>
    ///   Creating a sub-object inside a parent JSON structure:
    ///   <code>
    ///   var ParentJson, SubJson: TEasyJson;
    ///   begin
    ///     ParentJson := TEasyJson.Create;
    ///     SubJson := TEasyJson.Create(ParentJson.AddObject('address'), ParentJson, ejReference);
    ///     SubJson.Set('city', 'New York').Set('zipcode', '10001');
    ///     ShowMessage(ParentJson.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "address": {
    ///       "city": "New York",
    ///       "zipcode": "10001"
    ///     }
    ///   }
    ///   </code>
    /// </example>
    constructor Create(const AJsonValue: TJSONValue; AParent: TEasyJson; AOwnership: TejValueOwnership = ejReference); overload;

    /// <summary>
    ///   Destroys the <c>TEasyJson</c> instance and frees allocated resources.
    /// </summary>
    /// <remarks>
    ///   - If the instance owns the JSON value (<c>ejOwned</c>), it will be automatically freed.
    ///   - If the instance only references a JSON value (<c>ejReference</c>), the caller is responsible
    ///     for freeing the referenced JSON object.
    ///   - Any child objects or arrays created under this instance will also be cleaned up accordingly.
    /// </remarks>
    /// <example>
    ///   Example of automatic cleanup with ownership:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     try
    ///       EJ.Set('name', 'Alice');
    ///       ShowMessage(EJ.Format);
    ///     finally
    ///       EJ.Free; // Automatically frees the JSON structure
    ///     end;
    ///   end;
    ///   </code>
    /// </example>
    destructor Destroy(); override;

    /// <summary>
    ///   Sets a key-value pair in the JSON object.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the value will be stored.
    /// </param>
    /// <param name="AValue">
    ///   The value assigned to the key. It can be a string, number, boolean, or null.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance, allowing method chaining.
    /// </returns>
    /// <remarks>
    ///   - If the key already exists, its value is updated.
    ///   - If the key does not exist, it is created.
    ///   - This method provides a fluent interface for easy JSON construction.
    /// </remarks>
    /// <example>
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.Set('name', 'Alice').Set('age', 25);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "name": "Alice",
    ///     "age": 25
    ///   }
    ///   </code>
    /// </example>
    function &Set(const AKey: string; const AValue: Variant): TEasyJson; overload;

    /// <summary>
    ///   Sets a key-value pair in the JSON object where the value is another <c>TEasyJson</c> object.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the nested JSON object will be stored.
    /// </param>
    /// <param name="AJson">
    ///   The <c>TEasyJson</c> instance that will be inserted as the value.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance, enabling fluent method chaining.
    /// </returns>
    /// <remarks>
    ///   This method allows dynamic creation of nested JSON objects.
    /// </remarks>
    /// <example>
    ///   <code>
    ///   var ParentJson, ChildJson: TEasyJson;
    ///   begin
    ///     ParentJson := TEasyJson.Create;
    ///     ChildJson := TEasyJson.Create;
    ///     ChildJson.Set('city', 'New York').Set('zipcode', '10001');
    ///     ParentJson.Set('address', ChildJson);
    ///     ShowMessage(ParentJson.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "address": {
    ///       "city": "New York",
    ///       "zipcode": "10001"
    ///     }
    ///   }
    ///   </code>
    /// </example>
    function &Set(const AKey: string; const AJson: TEasyJson): TEasyJson; overload;

    /// <summary>
    ///   Sets a key-value pair in the JSON object where the value is a <c>TJSONValue</c>.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the JSON value will be stored.
    /// </param>
    /// <param name="AJSONValue">
    ///   A <c>TJSONValue</c> that represents a JSON-compatible structure.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    function &Set(const AKey: string; const AJSONValue: TJSONValue): TEasyJson; overload;

    /// <summary>
    ///   Sets a value at a specific index in a JSON array.
    /// </summary>
    /// <param name="AIndex">
    ///   The zero-based index where the value will be placed.
    /// </param>
    /// <param name="AValue">
    ///   The value to assign at the specified index.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    /// <remarks>
    ///   - If the index is out of bounds, behavior depends on internal error handling.
    ///   - This method is useful for modifying an existing JSON array.
    /// </remarks>
    /// <example>
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddArray('numbers').Set(0, 10).Set(1, 20);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "numbers": [10, 20]
    ///   }
    ///   </code>
    /// </example>
    function &Set(const AIndex: Integer; const AValue: Variant): TEasyJson; overload;

    /// <summary>
    ///   Sets a JSON array element at a specific index with another <c>TEasyJson</c> object.
    /// </summary>
    /// <param name="AIndex">
    ///   The zero-based index where the <c>TEasyJson</c> object will be stored.
    /// </param>
    /// <param name="AJson">
    ///   The <c>TEasyJson</c> instance to store at the specified index.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    function &Set(const AIndex: Integer; const AJson: TEasyJson): TEasyJson; overload;

    /// <summary>
    ///   Sets a JSON array element at a specific index with a <c>TJSONValue</c>.
    /// </summary>
    /// <param name="AIndex">
    ///   The zero-based index where the <c>TJSONValue</c> will be placed.
    /// </param>
    /// <param name="AJSONValue">
    ///   The <c>TJSONValue</c> to store at the specified index.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    function &Set(const AIndex: Integer; const AJSONValue: TJSONValue): TEasyJson; overload;

    /// <summary>
    ///   Adds a new key-value pair to the JSON object.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the value will be stored.
    /// </param>
    /// <param name="AValue">
    ///   The value assigned to the key. It can be a string, number, boolean, or null.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance, allowing method chaining.
    /// </returns>
    /// <remarks>
    ///   - If the key already exists, this method does <b>not</b> replace the existing value.
    ///   - If you need to update an existing key, use the <c>Set</c> method instead.
    ///   - This method is useful for building JSON objects dynamically where keys are unique.
    /// </remarks>
    /// <example>
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.Add('name', 'Alice').Add('age', 25);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "name": "Alice",
    ///     "age": 25
    ///   }
    ///   </code>
    /// </example>
    function Add(const AKey: string; const AValue: Variant): TEasyJson; overload;

    /// <summary>
    ///   Adds a new key with a <c>TEasyJson</c> object as its value.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the nested JSON object will be stored.
    /// </param>
    /// <param name="AJson">
    ///   The <c>TEasyJson</c> instance that will be inserted as a value.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    /// <remarks>
    ///   - The provided <c>AJson</c> instance is inserted as a sub-object.
    ///   - This method does not copy the instance; it references the passed <c>AJson</c> object.
    /// </remarks>
    /// <example>
    ///   <code>
    ///   var ParentJson, ChildJson: TEasyJson;
    ///   begin
    ///     ParentJson := TEasyJson.Create;
    ///     ChildJson := TEasyJson.Create;
    ///     ChildJson.Set('city', 'New York').Set('zipcode', '10001');
    ///     ParentJson.Add('address', ChildJson);
    ///     ShowMessage(ParentJson.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "address": {
    ///       "city": "New York",
    ///       "zipcode": "10001"
    ///     }
    ///   }
    ///   </code>
    /// </example>
    function Add(const AKey: string; const AJson: TEasyJson): TEasyJson; overload;

    /// <summary>
    ///   Adds a new key with a <c>TJSONValue</c> as its value.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the JSON value will be stored.
    /// </param>
    /// <param name="AJSONValue">
    ///   The <c>TJSONValue</c> that will be stored as the value.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    /// <remarks>
    ///   - This method is useful for working with raw <c>TJSONValue</c> objects.
    ///   - Ownership of the provided <c>AJSONValue</c> remains with the caller.
    /// </remarks>
    function Add(const AKey: string; const AJSONValue: TJSONValue): TEasyJson; overload;

    /// <summary>
    ///   Adds a new key with a <c>TJSONObject</c> as its value.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the JSON object will be stored.
    /// </param>
    /// <param name="AObject">
    ///   The <c>TJSONObject</c> instance that will be inserted as the value.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    /// <remarks>
    ///   - This method allows direct insertion of a <c>TJSONObject</c>.
    ///   - Unlike <c>TEasyJson</c>, <c>TJSONObject</c> does not support fluent chaining.
    /// </remarks>
    function Add(const AKey: string; const AObject: TJSONObject): TEasyJson; overload;

    /// <summary>
    ///   Adds a new key with a <c>TJSONArray</c> as its value.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the JSON array will be stored.
    /// </param>
    /// <param name="AnArray">
    ///   The <c>TJSONArray</c> instance to be inserted as a value.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    /// <remarks>
    ///   - This method is useful when adding pre-constructed JSON arrays into an object.
    ///   - Ownership of the provided <c>AnArray</c> remains with the caller.
    /// </remarks>
    /// <example>
    ///   <code>
    ///   var EJ: TEasyJson;
    ///       Arr: TJSONArray;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     Arr := TJSONArray.Create;
    ///     Arr.Add(10);
    ///     Arr.Add(20);
    ///     EJ.Add('numbers', Arr);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "numbers": [10, 20]
    ///   }
    ///   </code>
    /// </example>
    function Add(const AKey: string; const AnArray: TJSONArray): TEasyJson; overload;

    /// <summary>
    ///   Adds an unnamed empty object to the JSON structure.
    /// </summary>
    /// <returns>
    ///   A new <c>TEasyJson</c> instance representing the added object.
    /// </returns>
    /// <remarks>
    ///   - This method appends an empty object (<c>{}</c>) to the JSON structure.
    ///   - It is primarily used when adding objects inside an array.
    /// </remarks>
    /// <example>
    ///   The following example adds an empty object inside an array:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddArray('people')
    ///       .AddObject
    ///       .Set('name', 'Alice')
    ///       .Set('age', 25);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "people": [
    ///       {
    ///         "name": "Alice",
    ///         "age": 25
    ///       }
    ///     ]
    ///   }
    ///   </code>
    /// </example>
    function AddObject(): TEasyJson; overload;

    /// <summary>
    ///   Adds a named empty object to the JSON structure.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the new object will be stored.
    /// </param>
    /// <returns>
    ///   A new <c>TEasyJson</c> instance representing the added object.
    /// </returns>
    /// <remarks>
    ///   - This method is useful when inserting an empty object into a JSON dictionary,
    ///     where additional properties will be added later.
    /// </remarks>
    /// <example>
    ///   The following example adds an empty object with a key:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddObject('address').Set('city', 'New York').Set('zipcode', '10001');
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "address": {
    ///       "city": "New York",
    ///       "zipcode": "10001"
    ///     }
    ///   }
    ///   </code>
    /// </example>
    function AddObject(const AKey: string): TEasyJson; overload;

    /// <summary>
    ///   Adds a named object to the JSON structure using a callback function
    ///   for inline object creation.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the new object will be stored.
    /// </param>
    /// <param name="AFunc">
    ///   A callback function that receives a <c>TEasyJson</c> instance
    ///   and allows inline object construction.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    /// <example>
    ///   The following example adds a nested object using a callback function:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddObject('person',
    ///       function(EJ: TEasyJson): TEasyJson
    ///       begin
    ///         Result := EJ
    ///           .Set('name', 'John')
    ///           .Set('age', 30);
    ///       end);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "person": {
    ///       "name": "John",
    ///       "age": 30
    ///     }
    ///   }
    ///   </code>
    /// </example>
    function AddObject(const AKey: string; const AFunc: TFunc<TEasyJson, TEasyJson>): TEasyJson; overload;

    /// <summary>
    ///   Adds an anonymous object to the JSON structure using a callback function.
    /// </summary>
    /// <param name="AFunc">
    ///   A callback function that receives a <c>TEasyJson</c> instance
    ///   and allows inline object construction.
    /// </param>
    /// <returns>
    ///   The modified <c>TEasyJson</c> instance.
    /// </returns>
    /// <example>
    ///   The following example adds an object dynamically inside an array:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddArray('people')
    ///       .AddObject(
    ///         function(EJ: TEasyJson): TEasyJson
    ///         begin
    ///           Result := EJ
    ///             .Set('name', 'Alice')
    ///             .Set('age', 25);
    ///         end);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "people": [
    ///       {
    ///         "name": "Alice",
    ///         "age": 25
    ///       }
    ///     ]
    ///   }
    ///   </code>
    /// </example>
    function AddObject(const AFunc: TFunc<TEasyJson, TEasyJson>): TEasyJson; overload;

    /// <summary>
    ///   Adds an unnamed empty array to the JSON structure.
    /// </summary>
    /// <returns>
    ///   A new <c>TEasyJson</c> instance representing the added array.
    /// </returns>
    /// <remarks>
    ///   - This method appends an empty array (<c>[]</c>) to the JSON structure.
    ///   - It is primarily used when adding arrays inside an existing JSON structure.
    /// </remarks>
    /// <example>
    ///   The following example adds an empty array inside an object:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddObject('data').AddArray;
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "data": []
    ///   }
    ///   </code>
    /// </example>
    function AddArray(): TEasyJson; overload;

    /// <summary>
    ///   Adds a named empty array to the JSON structure.
    /// </summary>
    /// <param name="AKey">
    ///   The key under which the new array will be stored.
    /// </param>
    /// <returns>
    ///   A new <c>TEasyJson</c> instance representing the added array.
    /// </returns>
    /// <remarks>
    ///   - This method is useful when inserting an empty array into a JSON object
    ///     where elements will be added later.
    /// </remarks>
    /// <example>
    ///   The following example adds an empty array with a key:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddArray('numbers');
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "numbers": []
    ///   }
    ///   </code>
    /// </example>
    function AddArray(const AKey: string): TEasyJson; overload;

    /// <summary>
    ///   Navigates back to the parent <c>TEasyJson</c> instance.
    /// </summary>
    /// <returns>
    ///   The parent <c>TEasyJson</c> instance, allowing fluent navigation.
    /// </returns>
    /// <remarks>
    ///   - This method is useful when working with nested JSON structures.
    ///   - If called on the root instance, it may return itself or <c>nil</c>,
    ///     depending on the implementation.
    ///   - Designed to facilitate working within deeply nested JSON objects
    ///     while maintaining a fluent API.
    /// </remarks>
    /// <example>
    ///   The following example demonstrates how <c>Back</c> can be used to
    ///   navigate back from a nested JSON object:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddObject('person')
    ///       .Set('name', 'Alice')
    ///       .Set('age', 25)
    ///       .Back()  // Navigates back to the root
    ///       .Set('status', 'active');
    ///
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "person": {
    ///       "name": "Alice",
    ///       "age": 25
    ///     },
    ///     "status": "active"
    ///   }
    ///   </code>
    /// </example>
    function Back(): TEasyJson;

    /// <summary>
    ///   Navigates to the root <c>TEasyJson</c> instance.
    /// </summary>
    /// <returns>
    ///   The root <c>TEasyJson</c> instance.
    /// </returns>
    /// <remarks>
    ///   - This method allows easy access back to the root JSON object from
    ///     any nested level.
    ///   - If called on the root instance, it returns itself.
    /// </remarks>
    /// <example>
    ///   The following example demonstrates how <c>Root</c> can be used
    ///   to return to the top-level JSON object:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddObject('company')
    ///       .AddObject('address')
    ///         .Set('city', 'New York')
    ///         .Set('zipcode', '10001')
    ///         .Root()  // Navigates back to the root
    ///       .Set('name', 'TechCorp');
    ///
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "company": {
    ///       "address": {
    ///         "city": "New York",
    ///         "zipcode": "10001"
    ///       }
    ///     },
    ///     "name": "TechCorp"
    ///   }
    ///   </code>
    /// </example>
    function Root(): TEasyJson;

    /// <summary>
    ///   Returns the number of elements in the JSON object or array.
    /// </summary>
    /// <returns>
    ///   An integer representing the number of key-value pairs in a JSON object
    ///   or the number of elements in a JSON array.
    /// </returns>
    /// <remarks>
    ///   - If this instance represents a JSON object, <c>Count</c> returns the number of keys.
    ///   - If this instance represents a JSON array, <c>Count</c> returns the number of elements.
    ///   - If this instance is empty, <c>Count</c> returns <c>0</c>.
    /// </remarks>
    /// <example>
    ///   The following example demonstrates how <c>Count</c> behaves:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.Set('name', 'Alice').Set('age', 25);
    ///     ShowMessage(IntToStr(EJ.Count)); // Outputs: 2
    ///   end;
    ///   </code>
    /// </example>
    function Count(): Integer;

    /// <summary>
    ///   Serializes the JSON object into a compact string representation.
    /// </summary>
    /// <returns>
    ///   A <c>string</c> containing the JSON data in a single-line format.
    /// </returns>
    /// <remarks>
    ///   - The returned JSON string does not include line breaks or indentation.
    ///   - Use <c>Format</c> instead if you need human-readable formatting.
    /// </remarks>
    /// <example>
    ///   The following example converts a JSON object to a string:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.Set('name', 'Alice').Set('age', 25);
    ///     ShowMessage(EJ.ToString);
    ///     // Outputs: {"name":"Alice","age":25}
    ///   end;
    ///   </code>
    /// </example>
    function ToString(): string; override;

    /// <summary>
    ///   Returns a formatted JSON string with indentation for readability.
    /// </summary>
    /// <param name="AIndentation">
    ///   The number of spaces used for indentation. Default is <c>4</c>.
    /// </param>
    /// <returns>
    ///   A <c>string</c> containing a human-readable, pretty-printed JSON structure.
    /// </returns>
    /// <remarks>
    ///   - This method ensures that the JSON output is properly formatted with
    ///     line breaks and indentation.
    ///   - Useful for debugging and displaying JSON data in a readable format.
    /// </remarks>
    /// <example>
    ///   The following example generates a formatted JSON output:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.Set('name', 'Alice').Set('age', 25);
    ///     ShowMessage(EJ.Format);
    ///   end;
    ///   </code>
    ///   Output:
    ///   <code>
    ///   {
    ///     "name": "Alice",
    ///     "age": 25
    ///   }
    ///   </code>
    /// </example>
    function Format(const AIndentation: Integer = 4): string;

    /// <summary>
    ///   Retrieves the JSON value as a string.
    /// </summary>
    /// <returns>
    ///   A <c>string</c> representation of the JSON value.
    /// </returns>
    /// <remarks>
    ///   - If the JSON value is a string, it is returned as is.
    ///   - If the JSON value is a number, it is converted to a string.
    ///   - If the JSON value is a boolean, it is returned as <c>'true'</c> or <c>'false'</c>.
    ///   - If the JSON value is an object or array, behavior depends on implementation;
    ///     it may return an empty string or raise an exception.
    /// </remarks>
    function AsString(): string;

    /// <summary>
    ///   Retrieves the JSON value as an integer.
    /// </summary>
    /// <returns>
    ///   An <c>Integer</c> representation of the JSON value.
    /// </returns>
    /// <remarks>
    ///   - If the JSON value is an integer, it is returned directly.
    ///   - If the JSON value is a floating-point number, it is truncated to an integer.
    ///   - If the JSON value is a string containing a valid number, it is converted.
    ///   - If the JSON value is a boolean, <c>true</c> is converted to <c>1</c>, and <c>false</c> to <c>0</c>.
    ///   - If the JSON value cannot be converted, an exception may be raised.
    /// </remarks>
    function AsInteger(): Integer;

    /// <summary>
    ///   Retrieves the JSON value as a floating-point number.
    /// </summary>
    /// <returns>
    ///   A <c>Double</c> representation of the JSON value.
    /// </returns>
    /// <remarks>
    ///   - If the JSON value is a floating-point number, it is returned as is.
    ///   - If the JSON value is an integer, it is converted to a floating-point number.
    ///   - If the JSON value is a string containing a valid number, it is parsed as a floating-point value.
    ///   - If the JSON value is a boolean, <c>true</c> is converted to <c>1.0</c>, and <c>false</c> to <c>0.0</c>.
    ///   - If the JSON value cannot be converted, an exception may be raised.
    /// </remarks>
    function AsFloat(): Double;

    /// <summary>
    ///   Retrieves the JSON value as a boolean.
    /// </summary>
    /// <returns>
    ///   A <c>Boolean</c> representation of the JSON value.
    /// </returns>
    /// <remarks>
    ///   - If the JSON value is a boolean, it is returned as is.
    ///   - If the JSON value is a string, it is interpreted as follows:
    ///     - <c>'true'</c> (case insensitive) returns <c>True</c>.
    ///     - <c>'false'</c> (case insensitive) returns <c>False</c>.
    ///   - If the JSON value is a number:
    ///     - <c>0</c> is treated as <c>False</c>.
    ///     - Any nonzero value is treated as <c>True</c>.
    ///   - If the JSON value is an object or array, an exception may be raised.
    /// </remarks>
    function AsBoolean(): Boolean;

    /// <summary>
    ///   Retrieves the version of the <c>TEasyJson</c> library in
    ///   Semantic Versioning (SemVer) format.
    /// </summary>
    /// <returns>
    ///   A <c>string</c> representing the version number in the format
    ///   <c>major.minor.patch</c> (e.g., <c>1.2.3</c>).
    /// </returns>
    /// <remarks>
    ///   - The version follows the <c>Semantic Versioning (SemVer)</c> standard:
    ///     <list type="bullet">
    ///       <item><b>Major</b> - Increases when incompatible API changes are made.</item>
    ///       <item><b>Minor</b> - Increases when functionality is added in a backward-compatible manner.</item>
    ///       <item><b>Patch</b> - Increases when backward-compatible bug fixes are made.</item>
    ///     </list>
    ///   - This method allows developers to check which version of <c>TEasyJson</c> is being used
    ///     in their project for debugging or compatibility checks.
    /// </remarks>
    /// <example>
    ///   The following example retrieves and displays the current version:
    ///   <code>
    ///   var Version: string;
    ///   begin
    ///     Version := TEasyJson.GetVersion;
    ///     ShowMessage('TEasyJson Version: ' + Version);
    ///   end;
    ///   </code>
    ///   Example output:
    ///   <code>
    ///   TEasyJson Version: 1.0.0
    ///   </code>
    /// </example>
    class function GetVersion(): string;

    /// <summary>
    ///   Provides indexed access to JSON elements by key (for objects) or index (for arrays).
    /// </summary>
    /// <param name="AKeyOrIndex">
    ///   The key (if accessing a JSON object) or index (if accessing a JSON array) of the element.
    /// </param>
    /// <returns>
    ///   A <c>TEasyJson</c> instance representing the requested JSON element.
    /// </returns>
    /// <remarks>
    ///   - If this instance represents a JSON object, <c>AKeyOrIndex</c> must be a string corresponding
    ///     to a valid key in the object.
    ///   - If this instance represents a JSON array, <c>AKeyOrIndex</c> must be an integer specifying
    ///     the zero-based index of an element in the array.
    ///   - If the key does not exist in the object, behavior depends on implementation (it may return
    ///     <c>nil</c> or an empty <c>TEasyJson</c> instance).
    ///   - If the index is out of bounds, behavior depends on error handling (it may return <c>nil</c> or
    ///     raise an exception).
    ///   - This property supports Delphi's default property mechanism, allowing direct access via
    ///     <c>EasyJson['key']</c> or <c>EasyJson[0]</c> syntax.
    /// </remarks>
    /// <example>
    ///   The following example demonstrates accessing JSON object properties:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.Set('name', 'John').Set('age', 30);
    ///     ShowMessage(EJ['name'].AsString); // Outputs: John
    ///   end;
    ///   </code>
    ///
    ///   The following example demonstrates accessing JSON array elements:
    ///   <code>
    ///   var EJ: TEasyJson;
    ///   begin
    ///     EJ := TEasyJson.Create;
    ///     EJ.AddArray('numbers').Set(0, 10).Set(1, 20);
    ///     ShowMessage(IntToStr(EJ['numbers'][1].AsInteger)); // Outputs: 20
    ///   end;
    ///   </code>
    /// </example>
    property Items[const AKeyOrIndex: Variant]: TEasyJson read GetValue; default;

    end;

implementation

{ TEasyJson }

constructor TEasyJson.Create();
begin
  inherited Create();

  FJsonValue := TJSONObject.Create();
  FParent := nil;
  FOwnership := ejOwned;
end;

constructor TEasyJson.Create(const AJson: string);
var
  LParsedValue: TJSONValue;
begin
  inherited Create();

  LParsedValue := TJSONObject.ParseJSONValue(AJson);
  if LParsedValue <> nil then
    FJsonValue := LParsedValue
  else
    FJsonValue := TJSONObject.Create();

  FParent := nil;
  FOwnership := ejOwned;
end;

constructor TEasyJson.Create(const AJsonValue: TJSONValue; AOwnership: TejValueOwnership);
begin
  inherited Create();

  FJsonValue := AJsonValue;
  FParent := nil;
  FOwnership := AOwnership;
end;

constructor TEasyJson.Create(const AJsonValue: TJSONValue; AParent: TEasyJson; AOwnership: TejValueOwnership);
begin
  inherited Create();

  FJsonValue := AJsonValue;
  FParent := AParent;
  FOwnership := AOwnership;
end;

destructor TEasyJson.Destroy();
begin
  if (FOwnership = ejOwned) and (FJsonValue <> nil) then
    FJsonValue.Free;

  inherited;
end;

function TEasyJson.AsObject: TJSONObject;
begin
  if FJsonValue is TJSONObject then
    Result := TJSONObject(FJsonValue)
  else
    Result := nil;
end;

function TEasyJson.AsArray(): TJSONArray;
begin
  if FJsonValue is TJSONArray then
    Result := TJSONArray(FJsonValue)
  else
    Result := nil;
end;

(*
function TEasyJson.AsJSONValue(): TJSONValue;
begin
  Result := FJsonValue;
end;
*)

function TEasyJson.GetValue(const AKeyOrIndex: Variant): TEasyJson;
var
  LObj: TJSONObject;
  LArray: TJSONArray;
  LValue: TJSONValue;
begin
  if VarIsStr(AKeyOrIndex) then
  begin
    // Access by string key
    LObj := AsObject;
    if (LObj <> nil) and LObj.TryGetValue<TJSONValue>(string(AKeyOrIndex), LValue) then
      Result := TEasyJson.Create(LValue, Self, ejReference)
    else
      Result := TEasyJson.Create(TJSONNull.Create, Self, ejOwned);
  end
  else if VarType(AKeyOrIndex) in [varSmallint, varInteger, varByte, varWord, varLongWord, varInt64] then
  begin
    // Access by numeric index
    LArray := AsArray;
    if (LArray <> nil) and (Integer(AKeyOrIndex) >= 0) and (Integer(AKeyOrIndex) < LArray.Count) then
      Result := TEasyJson.Create(LArray.Items[Integer(AKeyOrIndex)], Self, ejReference)
    else
      Result := TEasyJson.Create(TJSONNull.Create, Self, ejOwned);
  end
  else
  begin
    // Invalid index type
    Result := TEasyJson.Create(TJSONNull.Create, Self, ejOwned);
  end;
end;

function TEasyJson.CreateJsonValue(const AValue: Variant): TJSONValue;
begin
  if VarIsNull(AValue) or VarIsEmpty(AValue) then
    Result := TJSONNull.Create
  else if VarType(AValue) in [varSmallint, varInteger, varByte, varWord, varLongWord, varInt64] then
    Result := TJSONNumber.Create(Integer(AValue))
  else if VarType(AValue) in [varSingle, varDouble, varCurrency] then
    Result := TJSONNumber.Create(Double(AValue))
  else if VarType(AValue) = varBoolean then
  begin
    if Boolean(AValue) then
      Result := TJSONTrue.Create
    else
      Result := TJSONFalse.Create;
  end
  else
    Result := TJSONString.Create(VarToStr(AValue));
end;

procedure TEasyJson.SafeAddPair(AObj: TJSONObject; const AName: string; AValue: TJSONValue);
var
  I: Integer;
  //LFound: Boolean;
begin
  if AObj = nil then
    Exit;

  // Look for existing pair with same name
  //LFound := False;
  for I := 0 to AObj.Count - 1 do
  begin
    if AObj.Pairs[I].JsonString.Value = AName then
    begin
      // Remove the existing pair and free it
      AObj.RemovePair(AName).Free;
      //LFound := True;
      Break;
    end;
  end;

  // Add the new pair
  AObj.AddPair(AName, AValue);
end;

function TEasyJson.GetOrCreateArray(AArray: TJSONArray; AIndex: Integer): TJSONArray;
var
  I: Integer;
begin
  Result := AArray;

  // Make sure we have enough elements
  if AIndex >= AArray.Count then
  begin
    for I := AArray.Count to AIndex do
    begin
      AArray.AddElement(TJSONNull.Create);
    end;
  end;
end;

function TEasyJson.&Set(const AKey: string; const AValue: Variant): TEasyJson;
var
  LObj: TJSONObject;
  LValue: TJSONValue;
begin
  LObj := AsObject;
  if LObj <> nil then
  begin
    LValue := CreateJsonValue(AValue);
    SafeAddPair(LObj, AKey, LValue);
  end;
  Result := Self;
end;

function TEasyJson.&Set(const AKey: string; const AJson: TEasyJson): TEasyJson;
begin
  if (AJson <> nil) and (AJson.FJsonValue <> nil) then
    &Set(AKey, AJson.FJsonValue.Clone as TJSONValue)
  else
    &Set(AKey, TJSONNull.Create);

  Result := Self;
end;

function TEasyJson.&Set(const AKey: string; const AJSONValue: TJSONValue): TEasyJson;
var
  LObj: TJSONObject;
  LClone: TJSONValue;
begin
  LObj := AsObject;
  if (LObj <> nil) and (AJSONValue <> nil) then
  begin
    LClone := AJSONValue.Clone as TJSONValue;
    SafeAddPair(LObj, AKey, LClone);
  end;
  Result := Self;
end;

function TEasyJson.&Set(const AIndex: Integer; const AValue: Variant): TEasyJson;
var
  LArray: TJSONArray;
  LValue: TJSONValue;
begin
  LArray := AsArray;
  if LArray <> nil then
  begin
    // Ensure array has enough elements
    GetOrCreateArray(LArray, AIndex);

    // Create the new value
    LValue := CreateJsonValue(AValue);

    // Replace the element
    if (AIndex >= 0) and (AIndex < LArray.Count) then
    begin
      // Free the old value
      LArray.Items[AIndex].Free();

      // Replace it - direct assignment doesn't work, so we need to remove and add
      LArray.Remove(AIndex);
      LArray.AddElement(LValue); // Changed Add to AddElement
    end;
  end;
  Result := Self;
end;

function TEasyJson.&Set(const AIndex: Integer; const AJson: TEasyJson): TEasyJson;
begin
  if (AJson <> nil) and (AJson.FJsonValue <> nil) then
    &Set(AIndex, AJson.FJsonValue.Clone as TJSONValue)
  else
    &Set(AIndex, TJSONNull.Create);

  Result := Self;
end;

function TEasyJson.&Set(const AIndex: Integer; const AJSONValue: TJSONValue): TEasyJson;
var
  LArray: TJSONArray;
  LClone: TJSONValue;
  LNewArray: TJSONArray;
  I: Integer;
begin
  LArray := AsArray;
  if (LArray <> nil) and (AJSONValue <> nil) then
  begin
    // Ensure array has enough elements
    GetOrCreateArray(LArray, AIndex);

    // Clone the JSON value
    LClone := AJSONValue.Clone as TJSONValue;

    // Replace the element
    if (AIndex >= 0) and (AIndex < LArray.Count) then
    begin
      // Create a new array with the updated element at the correct position
      LNewArray := TJSONArray.Create();
      try
        for I := 0 to LArray.Count - 1 do
        begin
          if I = AIndex then
            LNewArray.AddElement(LClone)
          else
            LNewArray.AddElement(LArray.Items[I].Clone as TJSONValue);
        end;

        // Replace the original array with the new one
        if FJsonValue = LArray then
        begin
          FJsonValue.Free();
          FJsonValue := LNewArray;
        end
        else
        begin
          // This is a complex case - we'd need to find and replace the array in its parent
          LNewArray.Free();
        end;
      except
        LNewArray.Free;
        LClone.Free;
        raise;
      end;
    end
    else
    begin
      LClone.Free(); // Clean up if we didn't use it
    end;
  end;
  Result := Self;
end;

function TEasyJson.Add(const AKey: string; const AValue: Variant): TEasyJson;
var
  LObj: TJSONObject;
  LValue: TJSONValue;
begin
  LObj := AsObject();
  if LObj <> nil then
  begin
    LValue := CreateJsonValue(AValue);
    LObj.AddPair(AKey, LValue);
  end;
  Result := Self;
end;

function TEasyJson.Add(const AKey: string; const AJson: TEasyJson): TEasyJson;
begin
  if (AJson <> nil) and (AJson.FJsonValue <> nil) then
    Add(AKey, AJson.FJsonValue.Clone as TJSONValue)
  else
    Add(AKey, TJSONNull.Create);

  Result := Self;
end;

function TEasyJson.Add(const AKey: string; const AJSONValue: TJSONValue): TEasyJson;
var
  LObj: TJSONObject;
  LClone: TJSONValue;
begin
  LObj := AsObject;
  if (LObj <> nil) and (AJSONValue <> nil) then
  begin
    LClone := AJSONValue.Clone as TJSONValue;
    LObj.AddPair(AKey, LClone);
  end;
  Result := Self;
end;

function TEasyJson.Add(const AKey: string; const AObject: TJSONObject): TEasyJson;
begin
  if AObject <> nil then
    Add(AKey, AObject as TJSONValue)
  else
    Add(AKey, TJSONNull.Create);

  Result := Self;
end;

function TEasyJson.Add(const AKey: string; const AnArray: TJSONArray): TEasyJson;
begin
  if AnArray <> nil then
    Add(AKey, AnArray as TJSONValue)
  else
    Add(AKey, TJSONNull.Create);

  Result := Self;
end;

function TEasyJson.AddObject(): TEasyJson;
var
  LObj: TJSONObject;
  LArray: TJSONArray;
begin
  LObj := TJSONObject.Create();

  if FJsonValue = nil then
  begin
    FJsonValue := LObj;
    Result := Self;
  end
  else if FJsonValue is TJSONArray then
  begin
    LArray := AsArray;
    LArray.Add(LObj);
    Result := TEasyJson.Create(LObj, Self, ejReference);
  end
  else
  begin
    LObj.Free();
    Result := Self;
  end;
end;

function TEasyJson.AddObject(const AKey: string): TEasyJson;
var
  LObj: TJSONObject;
  LParentObj: TJSONObject;
begin
  LParentObj := AsObject();
  if LParentObj <> nil then
  begin
    LObj := TJSONObject.Create();
    LParentObj.AddPair(AKey, LObj);
    Result := TEasyJson.Create(LObj, Self, ejReference);
  end
  else
    Result := Self;
end;

function TEasyJson.AddObject(const AKey: string; const AFunc: TFunc<TEasyJson, TEasyJson>): TEasyJson;
var
  LObj: TJSONObject;
  LParentObj: TJSONObject;
  LChildJson: TEasyJson;
begin
  LParentObj := AsObject();
  if LParentObj <> nil then
  begin
    LObj := TJSONObject.Create();
    LChildJson := TEasyJson.Create(LObj, Self, ejOwned);

    // Call the function to populate the object
    if Assigned(AFunc) then
      AFunc(LChildJson);

    // Add the object to the parent
    LParentObj.AddPair(AKey, LObj);

    // Free the wrapper but not the JSON object
    LChildJson.FOwnership := ejReference;
    LChildJson.Free();
  end;

  Result := Self;
end;

function TEasyJson.AddObject(const AFunc: TFunc<TEasyJson, TEasyJson>): TEasyJson;
var
  LObj: TJSONObject;
  LArray: TJSONArray;
  LChildJson: TEasyJson;
begin
  LObj := TJSONObject.Create();
  LChildJson := TEasyJson.Create(LObj, Self, ejOwned);

  // Call the function to populate the object
  if Assigned(AFunc) then
    AFunc(LChildJson);

  if FJsonValue is TJSONArray then
  begin
    // Add to array
    LArray := AsArray();
    LArray.Add(LObj);

    // Free the wrapper but not the JSON object
    LChildJson.FOwnership := ejReference;
    LChildJson.Free();

    Result := Self;
  end
  else if FJsonValue = nil then
  begin
    // This is the root
    FJsonValue := LObj;

    // Free the wrapper but not the JSON object
    LChildJson.FOwnership := ejReference;
    LChildJson.Free();

    Result := Self;
  end
  else
  begin
    // Invalid case
    LChildJson.Free();
    Result := Self;
  end;
end;

function TEasyJson.AddArray(): TEasyJson;
var
  LArray: TJSONArray;
  LParentArray: TJSONArray;
begin
  LArray := TJSONArray.Create();

  if FJsonValue = nil then
  begin
    FJsonValue := LArray;
    Result := Self;
  end
  else if FJsonValue is TJSONArray then
  begin
    LParentArray := AsArray();
    LParentArray.Add(LArray);
    Result := TEasyJson.Create(LArray, Self, ejReference);
  end
  else
  begin
    LArray.Free();
    Result := Self;
  end;
end;

function TEasyJson.AddArray(const AKey: string): TEasyJson;
var
  LArray: TJSONArray;
  LParentObj: TJSONObject;
begin
  LParentObj := AsObject();
  if LParentObj <> nil then
  begin
    LArray := TJSONArray.Create;
    LParentObj.AddPair(AKey, LArray);
    Result := TEasyJson.Create(LArray, Self, ejReference);
  end
  else
    Result := Self;
end;

function TEasyJson.Back(): TEasyJson;
begin
  if FParent <> nil then
    Result := FParent
  else
    Result := Self;
end;

function TEasyJson.Root(): TEasyJson;
var
  LCurrent: TEasyJson;
begin
  LCurrent := Self;
  while LCurrent.FParent <> nil do
    LCurrent := LCurrent.FParent;

  Result := LCurrent;
end;

function TEasyJson.Count(): Integer;
begin
  if FJsonValue is TJSONArray then
    Result := TJSONArray(FJsonValue).Count
  else if FJsonValue is TJSONObject then
    Result := TJSONObject(FJsonValue).Count
  else
    Result := 0;
end;

function TEasyJson.ToString(): string;
begin
  if FJsonValue <> nil then
    Result := FJsonValue.ToString
  else
    Result := '';
end;

function TEasyJson.Format(const AIndentation: Integer = 4): string;
begin
  if FJsonValue <> nil then
    Result := FJsonValue.Format(AIndentation)
  else
    Result := '';
end;

function TEasyJson.AsString(): string;
begin
  if FJsonValue is TJSONString then
    Result := TJSONString(FJsonValue).Value
  else if FJsonValue is TJSONNumber then
    Result := TJSONNumber(FJsonValue).ToString
  else if FJsonValue is TJSONTrue then
    Result := 'true'
  else if FJsonValue is TJSONFalse then
    Result := 'false'
  else if FJsonValue is TJSONNull then
    Result := 'null'
  else
    Result := '';
end;

function TEasyJson.AsInteger(): Integer;
begin
  if FJsonValue is TJSONNumber then
    Result := Round(TJSONNumber(FJsonValue).AsDouble)
  else if FJsonValue is TJSONString then
  begin
    if not TryStrToInt(TJSONString(FJsonValue).Value, Result) then
      Result := 0;
  end
  else if FJsonValue is TJSONTrue then
    Result := 1
  else if FJsonValue is TJSONFalse then
    Result := 0
  else
    Result := 0;
end;

function TEasyJson.AsFloat(): Double;
begin
  if FJsonValue is TJSONNumber then
    Result := TJSONNumber(FJsonValue).AsDouble
  else if FJsonValue is TJSONString then
  begin
    if not TryStrToFloat(TJSONString(FJsonValue).Value, Result) then
      Result := 0;
  end
  else if FJsonValue is TJSONTrue then
    Result := 1
  else if FJsonValue is TJSONFalse then
    Result := 0
  else
    Result := 0;
end;

function TEasyJson.AsBoolean(): Boolean;
begin
  if FJsonValue is TJSONTrue then
    Result := True
  else if FJsonValue is TJSONFalse then
    Result := False
  else if FJsonValue is TJSONNumber then
    Result := TJSONNumber(FJsonValue).AsDouble <> 0
  else if FJsonValue is TJSONString then
  begin
    if SameText(TJSONString(FJsonValue).Value, 'true') then
      Result := True
    else if SameText(TJSONString(FJsonValue).Value, 'false') then
      Result := False
    else
      Result := False;
  end
  else
    Result := False;
end;

class function TEasyJson.GetVersion(): string;
begin
  Result := '0.1.0';
end;

end.
