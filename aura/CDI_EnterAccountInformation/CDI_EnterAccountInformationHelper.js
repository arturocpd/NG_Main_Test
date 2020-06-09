({
    reportFldError : function(component,inputCmp,errorMsg) {
        inputCmp.setCustomValidity(errorMsg);
        inputCmp.reportValidity();
    },
    validateQPC : function(component){
        var qpcNum = component.find('qpcNum');
        var qpcVal = qpcNum.get('v.value');
        if(qpcVal % 1000 == 0 && (qpcVal/1000==4 || qpcVal/1000==5 || qpcVal/1000==6 || qpcVal/1000==7 ||
                                  qpcVal/1000==8 || qpcVal/1000==9 || qpcVal/1000==14 || qpcVal/1000==15 ||
                                  qpcVal/1000==16 || qpcVal/1000==17 || qpcVal/1000==18 || qpcVal/1000==19))
            this.reportFldError(component, qpcNum, '');    
        else 
            this.reportFldError(component, qpcNum, 'Please enter a valid QPC.');
    },
    validateFields : function(component,flag){
        var accNum = component.find('accNumber');
        if(flag){
            accNum.showHelpMessageIfInvalid();
        }
        var validEntryaccNum = accNum.get('v.validity').valid;
        var qpc = component.find('qpcNum');
        if(flag){
            qpc.showHelpMessageIfInvalid();
        }
        this.validateQPC(component);
        var validEntryQPC = qpc.get('v.validity').valid;
        if(validEntryaccNum && validEntryQPC){
            return true;
        } else {
            return false;
        }
    },
    /**************************************************************************
     helper method to Validate fields
    **************************************************************************/
    AccInfovalidateFields : function(component , showError) {
        var allValid = component.find('searchInput').reduce(function (validSoFar, inputCmp) {
            let iconTag = component.find(inputCmp.get("v.name"));
            if(showError) {
                if(inputCmp.get('v.validity').valid){
                    $A.util.addClass(iconTag, 'slds-hide');
                }else{
                    $A.util.removeClass(iconTag, 'slds-hide');
                }
                inputCmp.showHelpMessageIfInvalid();
            }
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        return allValid ;
    },
    validateFieldsInfo : function(component) {
        var noOfValidFields = 0;
        var validFields = ['city','street','lastName','zipCode','PHONE NUMBER'];
        var allValid = component.find('searchInput');
        for(var i=0;i<allValid.length;i++){
            if(validFields.includes(allValid[i].get('v.name'))){
                if(!($A.util.isUndefinedOrNull(allValid[i].get('v.value')))){
                   if(allValid[i].get('v.value') != 0)
                    noOfValidFields++;
                } 
            }
            
        }
        return noOfValidFields ;
    },
    searchAccount : function(component){
        let action = component.get("c.searchAccountAndQPC");
        action.setParams({
            "accountNum":component.get('v.accountNum'),
            "QPC":component.get('v.QPC')
        });
       
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                var searchResults = response.getReturnValue();
                component.set('v.isModalQPC',false); // Added Mohan CD-14986
                this.openModal(component,searchResults);          
            } else if (state === 'ERROR') {
                this.showToast('Error Occured','Invalid Data. Please try again.','error');           
            } else if (state === 'INCOMPLETE') {
                this.showToast('Error Occured','Unknown error. Please try again.','error');        
            } 
        });
        $A.enqueueAction(action);
    },
    
    showToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },
    /**************************************************************************
    Search Account information using last name and address
    **************************************************************************/   
    searchUsingAccountInfo : function(component){
        console.log('check::::');
        let action = component.get("c.searchAccountsUsingAddress");
        action.setParams({
            "accountAddressToSearch":JSON.stringify(component.get("v.accountDetailsToSearch"))
        });
        action.setCallback(this, function(response) {
            let state = response.getState(); 
            if (state === 'SUCCESS') {
                console.log('Sucess96');
                var searchResults = response.getReturnValue();
                console.log(searchResults.length);
                 console.log('test'+JSON.stringify(searchResults));
                if(searchResults.length > 0 && (searchResults[0].last4SSNDigits != null
                                                 || searchResults[0].DLNo!=null)){
                    this.createComponentSocialVerification(component,searchResults);
                }else{ 
                   component.set("v.isAccNotFound", true);
                    this.AccountNotFoundModal(component);
                }              
            } else if (state === 'ERROR') {
                this.showToast('Error Occured','Invalid Data. Please try again.','error');       
            } else if (state === 'INCOMPLETE') {
                this.showToast('Error Occured','Unknown error. Please try again.','error');        
            } 
        });
        
        $A.enqueueAction(action);
    },
    
    /**************************************************************************
     helper method to open modal based on result
    **************************************************************************/
    openModal : function(component,searchResults){
       // console.log('check'+JSON.stringify(searchResults));
        if(searchResults.length == 0)  {            
            this.AccountNotFoundModal(component);
        }
        if(searchResults.length == 1 && 
           searchResults[0].accountRecord.ParentId != null){ //Added by Kajal for CD-17133
            this.createComponentNotEligibleGuest(component);
        }       
        else if(searchResults.length == 1 && searchResults[0].accountRecord.CDI_DNACFromQPC__c != 'YES' 
                && searchResults[0].accountRecord.CDI_Online_Payment_Block__c != true
                &&	searchResults[0].AccountStatus != 'F'){         						 
            component.set('v.singleAccountRec',searchResults);
            component.set('v.isModalQPC',false);
            this.createComponentAccountLookupSingleResult(component,searchResults);
        }
            else if(searchResults.length == 1 && (searchResults[0].accountRecord.CDI_DNACFromQPC__c != 'NO' || 
                                                  searchResults[0].accountRecord.CDI_Online_Payment_Block__c != false)){  
                this.createComponentDNACMatch(component);
            }     
                else if(searchResults.length == 1 && 
                        (searchResults[0].AccountStatus == 'F' && 
                         searchResults[0].OpenBalanceExtention == 0	)) {
                    this.createComponentNotEligibleGuest(component);
                }
        else{
            	console.log('final else');
				 this.createComponentNotEligibleGuest(component);
            }
        
    },
    
    /**************************************************************************
     helper method to fetch suggestions from server
    **************************************************************************/
    validatePhoneNumber : function(component, inputCmp , phone) {
        //phone number should not be null and have proper length
        if ($A.util.isUndefinedOrNull(phone) || phone.length < 10){
            return ;
        }
        // cleaning the number and matching against regex
        var cleaned = ('' + phone).replace(/\D/g, '');
        if(cleaned.length < 10 && cleaned.length > 11){
            this.reportComponentValidity(inputCmp , $A.get('$Label.c.CDI_ValidPhoneNo'));
            return null;  
        }
        var match = cleaned.match(/^(1|)?(\d{3})(\d{3})(\d{4})$/);
        
        if (match) {
            var intlCode = (match[1] ? '+1 ' : '');
            phone= [intlCode, '(', match[2], ') ', match[3], '-', match[4]].join('')
        }else{
            this.reportComponentValidity(inputCmp , $A.get('$Label.c.CDI_ValidPhoneNo'));
            return null;
        }
        //+1 formatted number would show error -- if defect comes match pattern after removing +1 from phone.
        var patternRegex = new RegExp('^[(]?[2-9]\\d{2}[)]?[\\s]?[-]?[2-9]\\d{2}[\\s]?[-]?\\d{4}$');
        
        if (!patternRegex.test(phone)) {
            this.reportComponentValidity(inputCmp , $A.get('$Label.c.CDI_ValidPhoneNo'));
            return null;
        }
        
        patternRegex = new RegExp("^(\\d)\\1{9}|^(0123456789|1234567890)$");
        if (patternRegex.test(phone)) {
            this.reportComponentValidity(inputCmp , $A.get('$Label.c.CDI_ValidPhoneNo'));
            return null;
        }
        // setting the formated number
        this.reportComponentValidity(inputCmp , '');
        return phone ;                
    },
 
    /**************************************************************************
     Method to open modal when no account are found
    **************************************************************************/    
        AccountNotFoundModal : function(component, event, helper) {
           
            $A.createComponent(
                "c:CDI_AccountNotFoundWarning",{},
                function(myModal, status, errorMessage){
                    if (status === "ERROR")
                        console.log("Error: " + errorMessage);
                    else if (component.isValid() && status === "SUCCESS") {
                        var targetCmp = component.find('ModalDiv');
                        var body = targetCmp.get("v.body");
                        body.push(myModal);
                        targetCmp.set("v.body", body);
                    }
                }
            );
            /*uncommenting above to fix acc not found modal render on every search
        /* Defect fixed CD-14693*/ 
            component.set("v.isOpenGuest",true);
        },
            /**************************************************************************
     Method to open modal when single match is found
    **************************************************************************/   
        createComponentAccountLookupSingleResult : function(component,searchRes) {
         //   console.log('single acc match');
            console.log('single acc match'+JSON.stringify(searchRes));
            //let singleRec = JSON.stringify(component.get("v.singleAccountRec"));
              $A.createComponent(
                  "c:CDI_AccountLookupSingelResult",{'singleAccountRec':searchRes,
                                  				  	'isShowingMasking':true,
                                                     'serviceAddress':searchRes[0].accountRecord.CDI_Mailing_Address__c}, 
                                  				  	                           
                function(myModal, status, errorMessage){
                    if (status === "ERROR")
                        console.log("Error: " + errorMessage);
                    else if (component.isValid() && status === "SUCCESS") {
                        var targetCmp = component.find('ModalDiv');
                        var body = targetCmp.get("v.body");
                        body.push(myModal);
                        targetCmp.set("v.body", body);
                    }
                }
            );
            
        },
            /**************************************************************************
     Method to open modal when Account is DNAC or OPB
    **************************************************************************/   
        createComponentDNACMatch : function(component, event, helper) {
            $A.createComponent(
                "c:CDI_AccountDNACorOPB",{},
                function(myModal, status, errorMessage){
                    if (status === "ERROR")
                        console.log("Error: " + errorMessage);
                    else if (component.isValid() && status === "SUCCESS") {
                        var targetCmp = component.find('ModalDiv');
                        var body = targetCmp.get("v.body");
                        body.push(myModal);
                        targetCmp.set("v.body", body);
                    }
                }
            );
        },
            /**************************************************************************
     Method to open social modal for further verification
    **************************************************************************/   
        createComponentSocialVerification : function(component,searchRes) {           
            $A.createComponent(
                "c:CDI_SocialVerificationModal",{'wrapperRecord':searchRes},                                               
                function(myModal, status, errorMessage){
                    if (status === "ERROR")
                        console.log("Error: " + errorMessage);
                    else if (component.isValid() && status === "SUCCESS") {
                        var targetCmp = component.find('ModalDiv');
                        var body = targetCmp.get("v.body");
                        body.push(myModal);
                        targetCmp.set("v.body", body);
                    }
                }
            );
        },
            /**************************************************************************
     Method to open not eligible guest modal
    **************************************************************************/  
        createComponentNotEligibleGuest : function(component) {
            $A.createComponent(
                "c:CDI_NotEligibleGuestPayment",{},
                function(myModal, status, errorMessage){
                    if (status === "ERROR")
                        console.log("Error: " + errorMessage);
                    else if (component.isValid() && status === "SUCCESS") {
                        var targetCmp = component.find('ModalDiv');
                        var body = targetCmp.get("v.body");
                        body.push(myModal);
                        targetCmp.set("v.body", body);
                    }
                }
            );
        },
     /**************************************************************************
     helper method to fetch suggestions
    **************************************************************************/
    fetchSuggestions : function(component , value) {       
        if(value != null && value != '') {
            this.handleAutoComplete(component, value).then(
				records => {
                    if (records == null || records.length == 0) {
                    	component.set("v.typeAheadResults" , []);
                    //remove address bottom header class
                    let addressDiv = component.find("Address");
                    $A.util.removeClass(addressDiv, 'slds-border_bottom');
					}
					else { 
                //add address bottom header class
                         console.log('fetch suggestion else records'+records);
						component.set("v.typeAheadResults" , records); 
                        let addressDiv = component.find("Address");
                        $A.util.addClass(addressDiv, 'slds-border_bottom');
					}
				} 
			).catch(
                (err) => {
                    console.log("Error");
                }
            )
        }
        else {
            component.set("v.typeAheadResults" , []);
        }
    },
    
	 /**************************************************************************
     helper method (handleAutoComplete) to fetch suggestions from server
    **************************************************************************/
    handleAutoComplete : function(component, value) {        
       if(!$A.util.isUndefinedOrNull(value)) {
			let actionAutoComplete = component.get("c.getTypeAheadResults");
            actionAutoComplete.setParams({ searchString : value});			
			return new Promise($A.getCallback(function (resolve, reject) {
				actionAutoComplete.setCallback(this, function (response) {
					let state = response.getState();
					if (state === 'SUCCESS') {
                        console.log('callBack from typeahead'+JSON.stringify(response.getReturnValue()));
                         component.set('v.typeAheadResults',response.getReturnValue());
                        resolve(response.getReturnValue());
					} else if (state === 'ERROR') {
						reject(Error(response))
					}
				});
				$A.enqueueAction(actionAutoComplete);
			}))
		}
        else {
           
        	component.set("v.typeAheadResults" , []); 
            let addressDiv = component.find("Address");
            $A.util.removeClass(addressDiv, 'slds-border_bottom');
        }                     
    },
/**************************************************************************
     Method to show Warning Toast Message
**************************************************************************/
    showWarningToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : '',
            message: 'Please enter more information to lookup an account.',
            type: 'warning',
            mode: 'pester'
        });
        toastEvent.fire();
    },
 
    /***************************************************************************
	Method to add on change event listener to typeahead input textboxes
	***************************************************************************/ 
    addDebounce : function (component , event) {
        self = this;
        //define debounce method
        const debounce = (func, delay) => { 
            let debounceTimer
            return function() { 
            const context = this;
            const args = arguments; 
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => func.apply(context, args), delay);
        } 
        } ;
    
    	let debounceTime = 500;		
    
        debounce(function() {
           self.fetchSuggestions(component, event.getSource().get("v.value"));
        }, debounceTime)();
    }
    
})
