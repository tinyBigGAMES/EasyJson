{===============================================================================
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

unit UTestbed;

interface

uses
  System.SysUtils,
  EasyJson;

procedure RunTests();

implementation

(*=============================================================================
  Pause: Wait for User Input
  This procedure pauses the program execution and waits for the user to press
  ENTER before continuing. It is useful for preventing the console from closing
  immediately after execution, allowing the user to review output.
==============================================================================*)
procedure Pause();
begin
  // Print a blank line for spacing
  WriteLn;

  // Prompt the user to press ENTER to continue
  Write('Press ENTER to continue...');

  // Wait for the user to press ENTER
  ReadLn;

  // Print another blank line for spacing before resuming execution
  WriteLn;
end;

(*=============================================================================
  Test01: Creating a JSON Structure
  This procedure demonstrates how to build a JSON object using the TEasyJson
  fluent interface. It constructs a JSON structure containing an array of
  objects, each representing a text-based query.

  The JSON structure generated:
  {
    "contents": [
      {
        "parts": [
          { "text": "Who is Bill Gates?" },
          { "text": "Does he have kids?" }
        ]
      }
    ]
  }

  Steps performed:
  - A JSON object is created.
  - An array named "contents" is added.
  - A nested object is inserted into "contents".
  - A "parts" array is added within the nested object.
  - Two objects containing "text" values are inserted into "parts".
  - The final JSON structure is printed in a formatted manner.

  NOTE: This example highlights the simplicity and readability of TEasyJson's
        fluent interface when constructing hierarchical JSON structures.
==============================================================================*)
procedure Test01();
var
  LJson: TEasyJson;
begin
  // Create an instance of TEasyJson
  LJson := TEasyJson.Create();
  try
    // Add a 'contents' array to the JSON structure
    LJson.AddArray('contents')
      .AddObject()  // Add an object inside 'contents'
        .AddArray('parts')  // Add a 'parts' array inside the object
          .AddObject(function(AJson: TEasyJson): TEasyJson
            begin
              // Insert an object with a "text" field containing a query
              Result := AJson.&Set('text', 'Who is Bill Gates?');
            end)
          .AddObject(function(AJson: TEasyJson): TEasyJson
            begin
              // Insert another object with a different "text" query
              Result := AJson.&Set('text', 'Does he have kids?');
            end);

    // Print the formatted JSON output to the console
    WriteLn('JSON object:');
    WriteLn(LJson.Format());
  finally
    // Free the JSON object to prevent memory leaks
    LJson.Free();
  end;
end;

(*=============================================================================
  Test02: Parsing and Extracting JSON Data
  This procedure demonstrates how to parse a predefined JSON string using
  TEasyJson and extract specific values. It counts the number of candidates,
  prints the formatted JSON structure, and extracts the text content.

  The JSON structure being parsed:
  {
      "candidates": [
          {
              "content": {
                  "parts": [
                      {
                          "text": "Bill Gates is a renowned American business magnate..."
                      }
                  ]
              }
          }
      ]
  }

  Steps performed:
  - A TEasyJson instance is created and initialized with a JSON string.
  - The number of candidates in the JSON structure is counted and displayed.
  - The formatted JSON structure is printed for readability.
  - The first candidate's text content is extracted and printed.

  NOTE: This example showcases how TEasyJson simplifies JSON parsing, value
        retrieval, and structured data handling.
==============================================================================*)
procedure Test02();
const
  // Predefined JSON string containing a candidate with textual content
  CJson =
  '''
  {
      "candidates": [
          {
              "content": {
                  "parts": [
                      {
                          "text": "Bill Gates is a renowned American business magnate..."
                      }
                  ]
              }
          }
      ]
  }
  ''';
var
  LJson: TEasyJson;
  LText: string;
begin
  // Create a TEasyJson instance and load the predefined JSON string
  LJson := TEasyJson.Create(CJson);
  try
    // Print the number of candidates in the JSON structure
    Writeln('Candidates Count: ', LJson['candidates'].Count());

    // Print the formatted JSON object for readability
    WriteLn;
    WriteLn('JSON Object:');
    Writeln(LJson.Format());

    // Extract the text value from the first candidate's content
    LText := LJson['candidates'][0]['content']['parts'][0]['text'].AsString;

    // Print the extracted text content
    WriteLn;
    WriteLn('Extracted Text:');
    WriteLn(LText);
  finally
    // Free the JSON object to prevent memory leaks
    LJson.Free();
  end;
end;


(*=============================================================================
  Test03: Creating a Simple JSON Object
  This procedure demonstrates how to create a JSON object using the TEasyJson
  fluent interface. It sets key-value pairs and an array within the JSON
  structure.

  The JSON structure generated:
  {
    "name": "Alice",
    "age": 25,
    "hobbies": [
      "Reading",
      "Cycling"
    ]
  }

  Steps performed:
  - A TEasyJson instance is created.
  - Key-value pairs for "name" and "age" are added.
  - A "hobbies" array is added and populated with values.
  - The final JSON object is printed in a formatted manner.

  NOTE: This example illustrates how TEasyJson provides a simple and readable
        approach to JSON manipulation.
==============================================================================*)
procedure Test03();
var
  LJson: TEasyJson;
begin
  // Create an instance of TEasyJson
  LJson := TEasyJson.Create();
  try
    // Set name and age properties in the JSON object
    LJson.&Set('name', 'Alice')
      .&Set('age', 25)
      // Add an array named 'hobbies' and populate it
      .AddArray('hobbies')
        .&Set(0, 'Reading')
        .&Set(1, 'Cycling');

    // Print the formatted JSON output
    WriteLn('JSON Object:');
    WriteLn(LJson.Format());
  finally
    // Free the JSON object to prevent memory leaks
    LJson.Free;
  end;
end;

(*=============================================================================
  Test04: Creating a JSON Object from a String
  This procedure demonstrates how to initialize a JSON object from a
  predefined JSON string using the TEasyJson fluent interface.

  The JSON structure being parsed:
  {
    "name": "John",
    "age": 30
  }

  Steps performed:
  - A TEasyJson instance is created.
  - A predefined JSON string is loaded into the instance.
  - The formatted JSON structure is printed.

  NOTE: This example shows how TEasyJson can be used to load and format an
        existing JSON string efficiently.
==============================================================================*)
procedure Test04();
var
  LJson: TEasyJson;
begin
  // Create an instance of TEasyJson and load a JSON string
  LJson := TEasyJson.Create();
  try
    // Initialize the JSON object with a predefined JSON string
    LJson := TEasyJson.Create('{"name":"John","age":30}');

    // Print the formatted JSON output
    WriteLn;
    WriteLn('JSON Object:');
    WriteLn(LJson.Format());
  finally
    // Free the JSON object to prevent memory leaks
    LJson.Free;
  end;
end;

(*=============================================================================
  Test05: Adding and Modifying Values in a JSON Object
  This procedure demonstrates how to add new key-value pairs and modify
  existing values in a JSON object using the TEasyJson fluent interface.

  The initial JSON structure:
  {
    "name": "John",
    "age": 30
  }

  After modifications:
  {
    "name": "John",
    "age": 26,
    "email": "alice@example.com"
  }

  Steps performed:
  - A TEasyJson instance is created and initialized with a JSON string.
  - A new key-value pair "email" is added.
  - The existing "age" value is updated from 30 to 26.
  - The modified JSON structure is printed in a formatted manner.

  NOTE: This example showcases how TEasyJson allows dynamic updates to JSON
        structures while maintaining readability.
==============================================================================*)
procedure Test05();
var
  LJson: TEasyJson;
begin
  // Create an instance of TEasyJson and load a JSON string
  LJson := TEasyJson.Create();
  try
    // Initialize the JSON object with predefined data
    LJson := TEasyJson.Create('{"name":"John","age":30}');

    // Add a new key-value pair for "email"
    LJson.&Set('email', 'alice@example.com');

    // Update the existing "age" value from 30 to 26
    LJson.&Set('age', 26);

    // Print the formatted JSON output
    WriteLn;
    WriteLn('JSON Object:');
    WriteLn(LJson.Format());
  finally
    // Free the JSON object to prevent memory leaks
    LJson.Free;
  end;
end;

(*=============================================================================
  Test06: Working with JSON Arrays
  This procedure demonstrates how to create and manipulate JSON arrays using
  the TEasyJson fluent interface. It adds an array named "numbers" and
  populates it with integer values.

  The JSON structure generated:
  {
    "numbers": [10, 20, 30]
  }

  Steps performed:
  - A TEasyJson instance is created.
  - An array named "numbers" is added.
  - The array is populated with three integer values.
  - The modified JSON structure is printed in a formatted manner.

  NOTE: The `.Back()` method is used to navigate back to the parent object
        after modifying the array.
==============================================================================*)
procedure Test06();
var
  LJson: TEasyJson;
begin
  // Create an instance of TEasyJson
  LJson := TEasyJson.Create();
  try
    // Add an array named 'numbers' and populate it with values
    LJson.AddArray('numbers')
      .&Set(0, 10)
      .&Set(1, 20)
      .&Set(2, 30)
      .Back(); // Navigate back to the parent object

    // Print the formatted JSON output
    WriteLn;
    WriteLn('JSON Array:');
    WriteLn(LJson.Format());
  finally
    // Free the JSON object to prevent memory leaks
    LJson.Free;
  end;
end;


(*=============================================================================
  Test07: Nesting JSON Objects
  This procedure demonstrates how to create a nested JSON object using the
  TEasyJson fluent interface. It adds an "address" object containing two
  key-value pairs: "city" and "zip".

  The JSON structure generated:
  {
    "address": {
      "city": "New York",
      "zip": "10001"
    }
  }

  Steps performed:
  - A TEasyJson instance is created.
  - A nested object named "address" is added.
  - The "city" and "zip" properties are set inside "address".
  - The formatted JSON structure is printed.

  NOTE: This example showcases how TEasyJson simplifies the creation of nested
        JSON objects while maintaining readability.
==============================================================================*)
procedure Test07();
var
  LJson: TEasyJson;
begin
  // Create an instance of TEasyJson
  LJson := TEasyJson.Create();
  try
    // Add a nested object named 'address' and set its properties
    LJson.AddObject('address',
      function(AJson: TEasyJson): TEasyJson
      begin
        Result := AJson.&Set('city', 'New York')
                   .&Set('zip', '10001');
      end);

    // Print the formatted JSON output
    WriteLn;
    WriteLn('JSON Object:');
    WriteLn(LJson.Format());
  finally
    // Free the JSON object to prevent memory leaks
    LJson.Free;
  end;
end;

(*=============================================================================
  Test08: Nesting JSON Objects and Accessing Data
  This procedure demonstrates how to create a JSON object using the TEasyJson
  fluent interface. It sets key-value pairs, adds an array, and retrieves data
  from the generated JSON structure.

  The JSON structure generated:
  {
    "name": "Alice",
    "age": 25,
    "hobbies": [
      "Reading",
      "Cycling"
    ]
  }

  Steps performed:
  - A TEasyJson instance is created.
  - The key-value pairs "name" and "age" are set.
  - An array named "hobbies" is added and populated with values.
  - The JSON structure is printed in a formatted manner.
  - The stored JSON values are accessed and printed.

  Expected Output:
  - Name: Alice
  - Age: 25
  - hobbies[1]: Cycling

  NOTE: This example illustrates both JSON creation and value retrieval using
        TEasyJson, highlighting its ease of use.
==============================================================================*)
procedure Test08();
var
  LJson: TEasyJson;
begin
  // Create an instance of TEasyJson
  LJson := TEasyJson.Create();
  try
    // Set key-value pairs and add an array of hobbies
    LJson.&Set('name', 'Alice')
      .&Set('age', 25)
      .AddArray('hobbies')
        .&Set(0, 'Reading')
        .&Set(1, 'Cycling');

    // Print the formatted JSON output
    WriteLn;
    WriteLn('JSON Object:');
    WriteLn(LJson.Format());

    // Access and print individual JSON values
    WriteLn;
    WriteLn('Access JSON Data:');
    WriteLn('name      : ', LJson['name'].AsString);     // Alice
    WriteLn('age       : ', LJson['age'].AsInteger);    // 25
    WriteLn('hobbies[1]: ', LJson['hobbies'][1].AsString);  // Cycling
  finally
    // Free the JSON object to prevent memory leaks
    LJson.Free;
  end;
end;
(*=============================================================================
  RunTests: Execute Test Procedures
  This procedure runs one of the predefined test functions based on the value
  of LNum. It serves as a simple test runner using a case statement to call
  different test procedures.

  Steps performed:
  - The version of TEasyJson is printed.
  - A test number (LNum) is assigned to determine which test to execute.
  - A case statement calls the corresponding test procedure.
  - The Pause() function is invoked to allow the user to review output before
    terminating.

  Available Tests:
  01 - Test01: Creating a JSON Structure
  02 - Test02: Parsing and Extracting JSON Data
  03 - Test03: Creating a Simple JSON Object
  04 - Test04: Creating a JSON Object from a String
  05 - Test05: Adding and Modifying Values in a JSON Object
  06 - Test06: Working with JSON Arrays
  07 - Test07: Nesting JSON Objects
  08 - Test08: Nesting JSON Objects and Accessing Data

  NOTE: Modify the value of LNum to execute a different test case.
==============================================================================*)
procedure RunTests();
var
  LNum: Integer;
begin
  // Print the version of TEasyJson
  WriteLn('EasyJson v', TEasyJson.GetVersion());
  WriteLn;

  // Set the test number to execute (change this to run a different test)
  LNum := 01;

  // Execute the corresponding test procedure based on LNum
  case LNum of
    01: Test01();  // Runs Test01
    02: Test02();  // Runs Test02
    03: Test03();  // Runs Test03
    04: Test04();  // Runs Test04
    05: Test05();  // Runs Test05
    06: Test06();  // Runs Test06
    07: Test07();  // Runs Test07
    08: Test08();  // Runs Test08
  end;

  // Pause execution to allow the user to review output before termination
  Pause();
end;

end.
