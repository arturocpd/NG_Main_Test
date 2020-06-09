({
    /**************************************************************************
     Method to display toggle
    **************************************************************************/
    displayToggle : function(component, event, helper){
        var toggleText = component.find("tooltip");
        $A.util.toggleClass(toggleText, "slds-hide");
    },
    
    /**************************************************************************
     Method to go close previous modal - Added by Kajal on Feb 20 //TEST COMMENT BY KAJAL FOR DEPLOYMENT
    **************************************************************************/
    closeModal: function(component, event, helper) {        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({"url": "/"+$A.get('$Label.c.CDI_MakePaymentURL')});//Pavan Yendluri March 21 2020 Modified URL from MakePayment to makemayment CD-14442
        urlEvent.fire();
    },
    
    /**************************************************************************
     Method to go back to previous modal - Added by Kajal on Feb 20
    **************************************************************************/
    goBackModal: function(component, event, helper) { 
        var PaymentMode = component.getEvent("PaymentMode");
        PaymentMode.setParams({
            "isOpenGuest" : false,  "isOpenSelectHowToPay" : true, "isOpenSelectAccountLookup" : true });
        PaymentMode.fire();
        component.set("v.isModalQPC", false);
        component.set("v.isModalIdentifyAccount", false);        
    },
    
    /**************************************************************************
     Method to validate data entered and activate continue accordingly
    **************************************************************************/
    updateContinueBtnStyle : function(component, event, helper) {
        console.log('&&in update btn style');
        var isValid = helper.validateFields(component,false);
        var btn = component.find('continueBtn');
        var accNum = component.find("accNumber");
        var qpc = component.find("qpcNum");
        var accVal = accNum.get("v.value");
        var qpcVal = qpc.get("v.value");
        var btn = component.find('continueBtn');
        if(isValid==true){
           // $A.util.removeClass(btn, 'disableButton');
           component.set('v.isBtnDisabled',false);
            
        } else {     
           // $A.util.addClass(btn, 'disableButton');
           component.set('v.isBtnDisabled',true);
        }
        
    },
    
    /**************************************************************************
     Method to search account
    **************************************************************************/
    searchAccount : function(component, event, helper) {
        console.log('Search Account');
        var isValid = helper.validateFields(component,true);
        if(isValid){
            helper.searchAccount(component);
        }
    },
    
    /**************************************************************************
     Method to search account info
    **************************************************************************/
    searchAccountInfo : function(component, event, helper) {
       
        var count =  helper.validateFieldsInfo(component);
        if(count >= 2){
            component.set('v.isOpenGuest',true);
            helper.searchUsingAccountInfo(component);
        }else{
             helper.showWarningToast(component, event, helper); 
        }
            
    },
    
    /**************************************************************************
     Method to check QPC validity
    **************************************************************************/
    /*checkQPCValidity: function(component, event, helper) { 
        console.log('checkQPCValidity executed');
        var qpcNum = component.find('qpcNum');
        var qpcVal = qpcNum.get('v.value');
        if(qpcVal % 1000 == 0 && (qpcVal/1000==4 || qpcVal/1000==5 || qpcVal/1000==6 || qpcVal/1000==7 ||
                                  qpcVal/1000==8 || qpcVal/1000==9 || qpcVal/1000==14 || qpcVal/1000==15 ||
                                  qpcVal/1000==16 || qpcVal/1000==17 || qpcVal/1000==18 || qpcVal/1000==19))
            helper.reportFldError(component, qpcNum, '');    
        else 
            helper.reportFldError(component, qpcNum, 'Please enter a valid QPC.')
            
            },*/
    /**************************************************************************
     Method to call helper method to validate user details
    **************************************************************************/
    onInputBlur : function(component, event, helper) {
        
        let toggleButtonClass = component.find("srchBtn");
        if(!helper.AccInfovalidateFields(component, false)){
           // $A.util.addClass(toggleButtonClass, 'disableButton');
            component.set('v.isBtnDisabled',true);
        }else{
           // $A.util.removeClass(toggleButtonClass, 'disableButton');
            component.set('v.isBtnDisabled',false);
        }
        
        
    },
    /**************************************************************************
     Method to format phone number
    **************************************************************************/
    onPhoneBlur : function(component, event, helper) {
        let phone = helper.validatePhoneNumber(component, event.getSource() , event.getSource().get("v.value"));
        if(phone){
            event.getSource().set("v.value" , phone);
        }   
    },
     
    /**************************************************************************
     method to get typeahead suggestions
    **************************************************************************/
    onAddressChange : function(component, event, helper) {
        helper.addDebounce(component, event);
    },
    /**************************************************************************
     Method to hide results after field loses focus 
    **************************************************************************/
    hideSearchResultsOnBlur : function(component, event, helper) {
        //timeout so that option selected is set before being removed on blur
        /*
        setTimeout(
            $A.getCallback(function() {
                component.set("v.typeAheadResults" , []);
                let addressDiv = component.find("Address");
                $A.util.removeClass(addressDiv, 'slds-border_bottom');
            }), 100); 
            */
    },
     hideModal : function(component, event, helper) {
       if(event.getParam("isOpenGuest")){
            component.set("v.isOpenGuest",true);
        }else{
        	component.set("v.isOpenGuest", false);
        }   
          let accNm = component.get('v.accountNum');
            if(accNm != 'undefined' && accNm != '')
          component.set("v.isModalQPC",true);
       
	}, 
    hideModal2 : function(component, event, helper) {
        if(event.getParam("isOpenGuest")){        
            component.set("v.isOpenGuest",true);
        }else{  
        	component.set("v.isOpenGuest", false);
            let accNm = component.get('v.accountNum');
            if(accNm != 'undefined' && accNm != ''){ 
            component.set("v.isModalQPC", true);//Pavan Yendluri March 25 2020 Cd-15228
            }
        }
        
      	},
    /**************************************************************************
     method to handle redirection
    **************************************************************************/
    handleRedirectToParentEvent : function(component, event, helper) {
        if(event.getParam("firedTo") == "CDI_EnterAccountInformation"
           && event.getParam("firedFrom") == "CDI_MultipleAddressModal") {
            let childCmpToClose = event.getParam("cmp");      
            childCmpToClose.destroy();
            event.stopPropagation();
            component.set("v.isOpenGuest",false);	
            component.set("v.isModalIdentifyAccount",true);
        }
    },
     /**************************************************************************
     method to get set selected typeahead option
    **************************************************************************/
    chooseAddress : function(component, event, helper) {
        console.log('chooseAddress method');
        let option = event.target.parentElement.id;
        let addressSelected = option.split(',');
        console.log('selectedaddress'+addressSelected);
        if(addressSelected.length != 1){
            component.set("v.accountDetailsToSearch.ServiceAddress", addressSelected[0].trim());
           // component.set("v.accountDetailsToSearch.AptUnit", addressSelected[2].trim());
            component.set("v.accountDetailsToSearch.City", addressSelected[1].trim());
            component.set("v.accountDetailsToSearch.State", addressSelected[2].trim());
            component.set("v.accountDetailsToSearch.ZipCode", addressSelected[3].trim());
            addressSelected='';
        }
        component.set("v.typeAheadResults" , []);
        //add border class
        let addressDiv = component.find("Address");
        $A.util.removeClass(addressDiv, 'slds-border_bottom');
        
        var checkValidation = component.get('c.onInputBlur');
        $A.enqueueAction(checkValidation);
    },
     startSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
  
    endSpinner : function(component, event, helper){
        component.set("v.Spinner", false);
    },

   
})
