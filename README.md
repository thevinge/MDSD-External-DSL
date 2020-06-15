MDSD-External-DSL

JV - Individual Contribution

Example of a DSL Program, which has been used for testing during the development of the external DSL.
```
Test Ubicomp
        nameGen= <oneOf ["Jacob", "Andreas",<oneOf["Jens", "Anders",<String>, "Nicolaj", "John", "Oluf"]>]>

        name = {name:#nameGen}
        server = http://localhost:3000/
        changeIN = {name: ^ name, status:"IN"}
        modelName = {id:@id, name: ^ name }
        resBody = {userid:@id, id:-,status: ^ status , dt:-, name:-} 

        ResetHook http://localhost:3000/api/reset
    	
        request Getstatus
            GET
            server/api/status/@id
            Precondition: not empty
            STATE: none
            Postcondition: returns body resBody AND returns code 200 OR returns code 404
        request ChangeStatusOut
            POST
            http://localhost:3000/api/out/@id
            Precondition: not empty
            STATE: update {name: ^ name, status:"OUT"}
            Postcondition: returns code 200
        request ChangeStatusIn
            POST
            http://localhost:3000/api/in/@id
            Precondition: not empty
            STATE: update changeIN
            Postcondition: returns code 200
        request CreateUser
            POST
            http://localhost:3000/api/users/createOne
            body name
            STATE: create modelName
            Postcondition: returns code 200
```
