global with sharing class CRMLoginController {
    
    //Input variables
    global String input{get; set;}
    public String startURL{get; set;}
    public List<Auth.VerificationMethod> methods;
    public String error;
    
    global CRMLoginController () {
        startURL = 'https://ppplflogin-frostbank.cs196.force.com/PPPTestPWLess/s/';
        // Add verification methods in priority order
        methods = new List<Auth.VerificationMethod>();
        methods.add(Auth.VerificationMethod.SMS);
        methods.add(Auth.VerificationMethod.EMAIL);
        methods.add(Auth.VerificationMethod.U2F);
        methods.add(Auth.VerificationMethod.SALESFORCE_AUTHENTICATOR);
        methods.add(Auth.VerificationMethod.TOTP);
    }
    
    global PageReference login() {
        system.debug('entered login');
        List<User> users = null;
        // Empty input
        if(input== null || input== '') {
            error = 'Enter Username';
            return null;
        }
        users = [select name, id, email from User where email=:input];	// updated from 'name'
        //system.debug('==users ===' + users );
        if(users == null || users.isEmpty()) {
            error = 'Cannot find a user';
            return null;
        }
        if (startURL == null) startURL = '/';
        //system.debug('==startURL===' + startURL );
        PageReference pref = Site.passwordlessLogin(users[0].id, methods, startURL);
        
        /*
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        List<String> to = new List<String>();
        to.add('paul.karaffa@cloudpacific.tech');
        email.setToAddresses(to);
        email.setSubject('Debug log');
        email.setHtmlBody('pref: ' + pref + ' users: ' + users[0].id + ' methods: ' + methods + ' startURL: ' + startURL);
        emails.add(email);
        if(emails.size()>0)
            Messaging.sendEmail(emails);
        */
        
        return pref;
    }
}
