#Branch Best Practices In Project Management

##Branch Naming Conventions
1. Create parent branch with name of version name
    Format - 
        X.X.X.X 
        (Version Number. Sub Version Number. Build Number.Sub Build Number)

    Example - 
        Current Project version is 3.0.0.0
        Create following branch - 
            3.1.0.x
                    3.1.0.x_Development
                            3.1.0.x_Development_US12345

        So the main branch is - 3.1.0.X
        then create one Development branch - 3.1.0.x_Development

        Final PR will go from 3.1.0.x_Development --> 3.1.0.X

        Based user stories you can create branch in following format - 3.1.0.x_Development_<user_story_number> 
        Example - 3.1.0.x_Development_US12345

        So developer should create PR based on user story - 3.1.0.x_Development_US12345 ---> 3.1.0.x_Development

Scenario 1: If multiple developer working on same branch then in this case branch will create as following - 
            3.1.0.x_Development_US12345_Dev1
            3.1.0.x_Development_US12345_Dev2
            3.1.0.x_Development_US12345_Dev3

            then PR will create 
            3.1.0.x_Development_US12345_Dev1 --> 3.1.0.x_Development_US12345
            3.1.0.x_Development_US12345_Dev2 --> 3.1.0.x_Development_US12345
            3.1.0.x_Development_US12345_Dev3 --> 3.1.0.x_Development_US12345
            
            then team leader create PR 
            3.1.0.x_Development_US12345 --> 3.1.0.x_Development

            then 
            3.1.0.x_Development --> 3.1.0.x


            Do not mentioned developer name instead add "dev1" like that.

Scenario 2: If build goes successfully then version number should be increase and new branch will create

            3.1.1.x
            3.1.1.x_Development
            3.1.1.x_Development_<user_story_number>
            

Scenario 3: If previos build numbr user story found the bug then where it should be create?

            then it will create on new build version number with specify user story number

            3.1.1.x_Development_Bug12345





            


