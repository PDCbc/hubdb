/*
* Filters out providers based on id's and the initiative they are in.
*
* @param providerId {string} - the provider identifier to filter against.
* @param initiative {string} - the initiative identifier. One of: 
*       - "PPh" : polypharmacy
* 
* @returns - true if the provider is part of the specified initiative
*               false otherwise. 
*/
function filterProviders(providerId, initiative){

    //check that we have valid inputs
    if ( !providerId  || !initiative ) {

        return false; 

    }

    var inits = {

        "PPh" : [
            "cpsid",  //currently contains some test values.
            "PROVIDER1",
            "PROVIDER2"
        ]
    }; 


    //check that the initiative is valid.
    if ( inits[initiative] === undefined ){

        return false; 

    }

    if( inits[initiative].indexOf(providerId) > -1 ){

        return true;

    }else{

        return false; 

    }

}
