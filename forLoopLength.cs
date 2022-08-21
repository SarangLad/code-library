List<string> test = new List<string>(){"Apple", "Mango", "Coconut"};

//test.Count was wrong inside for loop
for (int i = 0; i < test.Count; i++)
{
    //do something    
}

//Better way intialize List Count before and use inside variable
int testLength = test.Count;
for (int j = 0; j < testLength; j++)
{
    //do something    
}