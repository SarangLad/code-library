public static DataTable EntityToDataTable<T>(List<T> items)
{
    DataTable dt = new DataTable(typeof(T).Name);

    PropertyInfo[] props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
    foreach (PropertyInfo prop in props)
    {
        DisplayNameAttribute displayNameAttribute = prop.GetCustomAttribute<DisplayNameAttribute>()!;
        if (ValidateObject.IsNotNull(displayNameAttribute))
        {
            string displayName = displayNameAttribute.DisplayName;
            dt.Columns.Add(displayName);
        }
        else
        {
            dt.Columns.Add(prop.Name);
        }
    }
    foreach (T item in items)
    {
        var values = new object[props.Length];
        for (int i = 0; i < props.Length; i++)
        {
            values[i] = props[i].GetValue(item, null)!;
        }
        dt.Rows.Add(values);
    }
    return dt;
}
public static FileContentResult ToCSV(this DataTable DataTable, string FileName)
{
    using (MemoryStream memoryStream = new MemoryStream())
    using (StreamWriter sw = new StreamWriter(memoryStream))
    {
        // Headers
        for (int i = 0; i < DataTable.Columns.Count; i++)
        {
            sw.Write(DataTable.Columns[i]);
            if (i < DataTable.Columns.Count - 1)
            {
                sw.Write(",");
            }
        }
        sw.Write(sw.NewLine);

        // Rows
        foreach (DataRow dr in DataTable.Rows)
        {
            for (int i = 0; i < DataTable.Columns.Count; i++)
            {
                if (!Convert.IsDBNull(dr[i]))
                {
                    string value = dr[i].ToString()!;
                    if (value.Contains(','))
                    {
                        value = String.Format("\"{0}\"", value);
                        sw.Write(value);
                    }
                    else
                    {
                        sw.Write(dr[i].ToString());
                    }
                }
                if (i < DataTable.Columns.Count - 1)
                {
                    sw.Write(",");
                }
            }
            sw.Write(sw.NewLine);
        }

        sw.Flush();

        memoryStream.Position = 0; // Reset position for reading
        return new FileContentResult(memoryStream.ToArray(), "text/csv")
        {

            FileDownloadName = FileName
        };
    }
}
public static DataTable ConvertCSVToDataTable(IFormFile excelFile)
{
    int ColumnCount = 0;
    DataTable dt = new DataTable();
    if (excelFile == null || excelFile.Length <= 0)
    {
        return dt;
        //return BadRequest("No file uploaded.");
    }

    using (var reader = new StreamReader(excelFile.OpenReadStream()))
    {
        bool isFirstRow = true;
        while (!reader.EndOfStream)
        {
            string line = reader.ReadLine();

            string[] values = SplitCsvLine(line);
            //string[] values = line.Split(',');

            if (isFirstRow)
            {
                foreach (string header in values)
                {
                    dt.Columns.Add(header);
                }
                isFirstRow = false;
                ColumnCount = dt.Columns.Count;
            }
            else
            {
                DataRow row = dt.NewRow();
                for (int i = 0; i < ColumnCount; i++)
                {
                    row[i] = values[i];
                }
                dt.Rows.Add(row);
            }
        }
    }
    return dt;
}
public static string[] SplitCsvLine(string line)
{
    List<string> values = new List<string>();
    StringBuilder currentField = new StringBuilder();
    bool inQuotes = false;

    foreach (char c in line)
    {
        if (c == '"')
        {
            inQuotes = !inQuotes;
        }
        else if (c == ',' && !inQuotes)
        {
            values.Add(currentField.ToString());
            currentField.Clear();
        }
        else
        {
            currentField.Append(c);
        }
    }

    values.Add(currentField.ToString());

    return values.ToArray();
}
public static List<string>? GetFormatColumns(IFormFile ExcelFile)
{
    List<string>? SampleExcelColName = new List<string>();

    string TempFilePath = Path.GetTempFileName();
    using (FileStream stream = new FileStream(TempFilePath, FileMode.Create))
    {
        ExcelFile.CopyTo(stream);
    }

    //string SampleExcelFilePath = @"D:/QsSupplyClone/QsSupplies.Backend.UI/wwwroot/ExcelFile/" + SampleFileName;
    using (TextFieldParser parser = new TextFieldParser(TempFilePath))
    {
        parser.TextFieldType = FieldType.Delimited;
        parser.SetDelimiters(",");

        if (!parser.EndOfData)
        {
            string[] headerFields = parser.ReadFields()!;
            SampleExcelColName.AddRange(headerFields);
        }
    }
    File.Delete(TempFilePath);
    return SampleExcelColName;
}
public static bool ValidateColumn(List<string> dataTableColumn, List<string> modelPropertyColumn)
{
    if (dataTableColumn.Count != modelPropertyColumn.Count)
    {
        return false;
    }

    HashSet<string> set1 = new HashSet<string>(
    dataTableColumn.Select(item => item.Replace(" ", "").Trim()),
    StringComparer.OrdinalIgnoreCase);

    HashSet<string> set2 = new HashSet<string>(
        modelPropertyColumn.Select(item => item.Replace(" ", "").Trim()),
        StringComparer.OrdinalIgnoreCase);

    return set1.SetEquals(set2);

}
public static (List<T> ModelList, string ErrorMessage) ConvertDataTableToModelList<T>(this DataTable dataTable) where T : new()
{
    List<T> modelList = new List<T>();
    StringBuilder errorMessagsBuilder = new StringBuilder();
    foreach (DataRow row in dataTable.Rows)
    {
        T model = new T();

        Type modelType = typeof(T);
        int test = 0;//for testing
        foreach (DataColumn column in dataTable.Columns)
        {
            string columnName = column.ColumnName.Replace(" ", "");

            PropertyInfo[] properties = modelType.GetProperties();

            foreach (PropertyInfo propertyTest in properties)
            {
                DisplayNameAttribute displayNameAttribute = propertyTest.GetCustomAttribute<DisplayNameAttribute>();
                if (displayNameAttribute != null)
                {

                    string displayName = displayNameAttribute.DisplayName;

                    if (displayName.Replace(" ", "") == columnName.Replace(" ", ""))
                    {
                        PropertyInfo property = typeof(T).GetProperty(propertyTest.Name);

                        if (property != null && row[column.ColumnName] != DBNull.Value)
                        {
                            try
                            {
                                if (property.PropertyType.IsGenericType && property.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>))
                                {
                                    Type underlyingType = Nullable.GetUnderlyingType(property.PropertyType);
                                    if (underlyingType != null)
                                    {
                                        if (row[column.ColumnName] != DBNull.Value)
                                        {
                                            try
                                            {
                                                string stringValue = row[column.ColumnName].ToString();
                                                if (!string.IsNullOrEmpty(stringValue))
                                                {
                                                    object convertedValue = Convert.ChangeType(stringValue, underlyingType);
                                                    property.SetValue(model, convertedValue);
                                                }
                                                else
                                                {
                                                    property.SetValue(model, Activator.CreateInstance(underlyingType)); // Set property to default value (0 for int)

                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                errorMessagsBuilder.AppendLine($"Error setting value for property {property.Name}: {ex.Message}");
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if (row[column.ColumnName] != DBNull.Value)
                                    {
                                        try
                                        {
                                            string stringValue = row[column.ColumnName].ToString();
                                            if (property.PropertyType == typeof(int))
                                            {
                                                if (string.IsNullOrEmpty(stringValue))
                                                {
                                                    property.SetValue(model, 0);
                                                }
                                                else if (int.TryParse(stringValue, out int intValue))
                                                {
                                                    property.SetValue(model, intValue);
                                                }
                                                else
                                                {
                                                    // Log or handle the invalid value
                                                    errorMessagsBuilder.AppendLine($"Invalid value for property {property.Name}: {stringValue}");
                                                }
                                            }
                                            else if (property.PropertyType == typeof(float)) // Add this block for float properties
                                            {
                                                if (string.IsNullOrEmpty(stringValue))
                                                {
                                                    property.SetValue(model, null);
                                                }
                                                else if (float.TryParse(stringValue, out float floatValue))
                                                {
                                                    property.SetValue(model, floatValue);
                                                }
                                                else
                                                {
                                                    errorMessagsBuilder.AppendLine($"Invalid value for property {property.Name}: {stringValue}");
                                                }
                                            }
                                            else if (property.PropertyType == typeof(double)) // Note the change in type to double?
                                            {
                                                if (string.IsNullOrEmpty(stringValue))
                                                {
                                                    property.SetValue(model, 0); // Set to null if the string is empty
                                                }
                                                else if (double.TryParse(stringValue, out double doubleValue))
                                                {
                                                    property.SetValue(model, doubleValue);
                                                }
                                                else
                                                {
                                                    errorMessagsBuilder.AppendLine($"Invalid value for property {property.Name}: {stringValue}");
                                                }
                                            }
                                            else if (property.PropertyType == typeof(bool))
                                            {
                                                int value = 0;
                                                if (!string.IsNullOrEmpty(stringValue))
                                                {
                                                    value = int.Parse(stringValue);
                                                }
                                                if (string.IsNullOrEmpty(stringValue) || stringValue == "0")
                                                {
                                                    property.SetValue(model, false); // Set a default value for empty strings
                                                }
                                                else if (value >= 1)
                                                {
                                                    property.SetValue(model, true);
                                                }
                                                else
                                                {
                                                    errorMessagsBuilder.AppendLine($"Invalid value for property {property.Name}: {stringValue}");
                                                }
                                            }
                                            else
                                            {
                                                // For other property types, use Convert.ChangeType
                                                object convertedValue = Convert.ChangeType(stringValue, property.PropertyType);
                                                property.SetValue(model, convertedValue);
                                            }
                                            // property.SetValue(model, Convert.ChangeType(row[column.ColumnName], property.PropertyType));
                                        }
                                        catch (Exception ex)
                                        {
                                            errorMessagsBuilder.AppendLine($"Error setting value for property {property.Name}: {ex.Message}");
                                        }
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                errorMessagsBuilder.AppendLine($"Error setting value for property {property.Name}: {ex.Message}");
                            }
                        }

                    }
                }

            }
            test++;
        }
        modelList.Add(model);
    }
    string ErrorMessage = errorMessagsBuilder.ToString();
    return (modelList, ErrorMessage);
}

private static Dictionary<string, string> GetModelTypesMap(DataColumnCollection columnCollection, PropertyInfo[] properties)
{
    Dictionary<string, string> hashMap = new Dictionary<string, string>();
    foreach (DataColumn column in columnCollection)
    {
        string columnName = column.ColumnName.Trim();
        PropertyInfo property = properties.FirstOrDefault(x => x.GetCustomAttribute<DisplayNameAttribute>().DisplayName.Equals(columnName, StringComparison.OrdinalIgnoreCase) || x.Name.Equals(columnName, StringComparison.OrdinalIgnoreCase));

        hashMap.Add(columnName, property?.Name ?? throw new Exception("Invalid Object selected to map : Unable to map property name:" + columnName));
    }
    return hashMap;
}
private static List<T> GetModelList<T>(Dictionary<string, string> hashMap, DataTable dataTable) where T : new()
{
    List<T> modelList = new List<T>();

    foreach (DataRow row in dataTable.Rows)
    {
        T model = new T();
        foreach (DataColumn column in dataTable.Columns)
        {
            string columnName = column.ColumnName;
            string propertyName = hashMap.GetValueOrDefault(column.ColumnName.Trim());
            PropertyInfo property = typeof(T).GetProperty(propertyName);

            if (row[columnName] != DBNull.Value)
            {
                property.SetValue(model, Convert.ChangeType(row[columnName], property.PropertyType));
            }
        }

        modelList.Add(model);
    }
    return modelList;
}
public static List<T> ConvertDataTableToModelListV2<T>(this DataTable dataTable) where T : new()
{
    List<T> modelList = new List<T>();
    Type modelType = typeof(T);
    PropertyInfo[] properties = modelType.GetProperties();
    DataColumnCollection columnCollection = dataTable.Columns;
    Dictionary<string, string> hashMap = GetModelTypesMap(columnCollection, properties);
    modelList = GetModelList<T>(hashMap, dataTable);
    return modelList;
}

public static string ReadFile(string hostingEnv, string path)
{
    path = path.Trim().Replace(@"/", @"\");

    string result = string.Empty;
    // Get the current directory of the application
    string currentDirectory = Environment.CurrentDirectory;
    string filePath = string.Concat(hostingEnv, path);


    if (File.Exists(filePath))
    {
        result = File.ReadAllText(filePath);
    }
    return result;
}
public static async Task<string> ReadDataFromUrlAsync(string url)
{
    string result = string.Empty;
    HttpClient httpClient = new HttpClient();

    HttpResponseMessage response = await httpClient.GetAsync(url);
    if (response.IsSuccessStatusCode)
    {
        result = await response.Content.ReadAsStringAsync();
    }
    return result;
}

public static DataTable ConvertListToDataTable<T>(List<T> items)
{
    DataTable dt = new DataTable(typeof(T).Name);

    PropertyInfo[] props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
    foreach (PropertyInfo prop in props)
    {
        DisplayNameAttribute displayNameAttribute = prop.GetCustomAttribute<DisplayNameAttribute>();
        string columnName = (displayNameAttribute != null) ? displayNameAttribute.DisplayName : prop.Name;
        dt.Columns.Add(columnName);
    }

    foreach (T item in items)
    {
        var values = new object[props.Length];
        for (int i = 0; i < props.Length; i++)
        {
            values[i] = props[i].GetValue(item, null)!;
        }
        dt.Rows.Add(values);
    }

    return dt;
}
public static FileContentResult ToCSVWithoutHeaders(this DataTable DataTable, string FileName)
{
    using (MemoryStream memoryStream = new MemoryStream())
    using (StreamWriter sw = new StreamWriter(memoryStream))
    {
        // Rows only, skipping headers
        foreach (DataRow dr in DataTable.Rows)
        {
            for (int i = 0; i < DataTable.Columns.Count; i++)
            {
                if (!Convert.IsDBNull(dr[i]))
                {
                    string value = dr[i].ToString()!;
                    if (value.Contains(','))
                    {
                        value = String.Format("\"{0}\"", value);
                        sw.Write(value);
                    }
                    else
                    {
                        sw.Write(dr[i].ToString());
                    }
                }
                if (i < DataTable.Columns.Count - 1)
                {
                    sw.Write(",");
                }
            }
            sw.Write(sw.NewLine);
        }

        sw.Flush();

        memoryStream.Position = 0; // Reset position for reading
        return new FileContentResult(memoryStream.ToArray(), "text/csv")
        {
            FileDownloadName = FileName
        };
    }
}

public static FileContentResult ToXML(this DataTable DataTable, string FileName)
{
    using (MemoryStream memoryStream = new MemoryStream())
    {
        DataTable.WriteXml(memoryStream);

        memoryStream.Position = 0;
        return new FileContentResult(memoryStream.ToArray(), "application/xml")
        {
            FileDownloadName = FileName + ".xml"
        };
    }
}

public static string CheckNullValue(string value)
{
    string result = string.Empty;
    if (value != null)
    {
        result = value;
    }
    else
    {
        value = null;
    }
    return result;
}


public static string ExtractOrderIDsFromCsv(IFormFile excelFile)
{
    StringBuilder orderIDs = new StringBuilder();

    using (var reader = new StreamReader(excelFile.OpenReadStream()))
    {
        while (!reader.EndOfStream)
        {
            string line = reader.ReadLine();
            string[] values = line.Split(',');

            if (values.Length > 0)
            {
                // Assuming the Order IDs are in the first column (index 0)
                orderIDs.Append(values[0]).Append(",");
            }
        }
    }

    if (orderIDs.Length > 0)
    {
        // Remove the trailing comma and return the string
        return orderIDs.ToString().TrimEnd(',');
    }
    else
    {
        return "No Order IDs found in the file.";
    }
}
public static string Encrypt(string plainText, string secret)
{
    using (Aes aesAlg = Aes.Create())
    {
        aesAlg.Key = Encoding.UTF8.GetBytes(secret);
        aesAlg.Mode = CipherMode.ECB;
        aesAlg.Padding = PaddingMode.PKCS7;

        using (ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV))
        using (MemoryStream msEncrypt = new MemoryStream())
        using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
        {
            byte[] plainBytes = Encoding.UTF8.GetBytes(plainText);
            csEncrypt.Write(plainBytes, 0, plainBytes.Length);
            csEncrypt.FlushFinalBlock();

            byte[] encryptedBytes = msEncrypt.ToArray();
            return Convert.ToBase64String(encryptedBytes);
        }
    }
}


public static byte[] Decrypt(byte[] cipherText, string secret)
{
    using (Aes aesAlg = Aes.Create())
    {
        aesAlg.Key = Encoding.UTF8.GetBytes(secret);
        aesAlg.Mode = CipherMode.ECB;
        aesAlg.Padding = PaddingMode.PKCS7;

        using (ICryptoTransform decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV))
        using (MemoryStream msDecrypt = new MemoryStream(cipherText))
        using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
        using (MemoryStream msPlain = new MemoryStream())
        {
            csDecrypt.CopyTo(msPlain);
            return msPlain.ToArray();
        }
    }
}

public static string FormatDate(DateTime? date)
{
    if (date.HasValue)
    {
        DateTimeFormatInfo dtInfo = new DateTimeFormatInfo();
        return $"{date.Value.Day} {dtInfo.GetMonthName(date.Value.Month)}, {date.Value.Year}";
    }
    else
    {
        return "";
    }
}

public static FileContentResult ToAutofitCSV(this DataTable DataTable, string FileName)
{
    using (MemoryStream memoryStream = new MemoryStream())
    using (StreamWriter sw = new StreamWriter(memoryStream))
    {
        // Headers
        for (int i = 0; i < DataTable.Columns.Count; i++)
        {
            sw.Write(DataTable.Columns[i]);
            if (i < DataTable.Columns.Count - 1)
            {
                sw.Write(",");
            }
        }
        sw.Write(sw.NewLine);


        // Rows
        foreach (DataRow dr in DataTable.Rows)
        {
            for (int i = 0; i < DataTable.Columns.Count; i++)
            {
                if (!Convert.IsDBNull(dr[i]))
                {
                    string value = CleanCellValue(dr[i].ToString());
                    if (value.Contains(','))
                    {
                        value = String.Format("\"{0}\"", value);
                    }

                    // Write value without padding
                    sw.Write(value);
                }

                if (i < DataTable.Columns.Count - 1)
                {
                    sw.Write(",");
                }
            }
            sw.Write(sw.NewLine);
        }

        // Auto-fit column widths based on content
        for (int i = 0; i < DataTable.Columns.Count; i++)
        {
            int maxColumnWidth = DataTable.AsEnumerable().Max(r => CleanCellValue(r[i]?.ToString()).Length) + 2; // Adding extra padding
            sw.Write(new string(' ', maxColumnWidth));
            if (i < DataTable.Columns.Count - 1)
            {
                sw.Write(",");
            }
        }
        sw.Write(sw.NewLine);

        sw.Flush();

        // Reset position for reading
        memoryStream.Position = 0;


        // Create CSV file content result
        return new FileContentResult(memoryStream.ToArray(), "text/csv")
        {
            FileDownloadName = FileName
        };
    }
}
public static DataTable ConvertAutoFitListToDataTable<T>(List<T> items)
{
    DataTable dt = new DataTable(typeof(T).Name);

    PropertyInfo[] props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
    foreach (PropertyInfo prop in props)
    {
        DisplayNameAttribute displayNameAttribute = prop.GetCustomAttribute<DisplayNameAttribute>();
        string columnName = (displayNameAttribute != null) ? displayNameAttribute.DisplayName : prop.Name;

        // Determine the underlying type of the property, handling Nullable<T>
        Type columnType = Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType;

        dt.Columns.Add(columnName, columnType);
    }

    foreach (T item in items)
    {
        var values = new object[props.Length];
        for (int i = 0; i < props.Length; i++)
        {
            values[i] = props[i].GetValue(item, null)!;
        }
        dt.Rows.Add(values);
    }

    return dt;
}

private static string CleanCellValue(string value)
{
    // Remove HTML tags using HtmlAgilityPack
    value = System.Text.RegularExpressions.Regex.Replace(value, "<.*?>", "");

    // Replace line breaks and commas within the cell content
    value = value.Replace("\r\n", " ").Replace("\n", " ").Replace("\r", " ").Replace(",", ";");

    return value;
}