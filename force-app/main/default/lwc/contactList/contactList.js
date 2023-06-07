import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import FirstNameLabel from '@salesforce/label/c.FirstName';
import LastNameLabel from '@salesforce/label/c.LastName';
import EmailLabel from '@salesforce/label/c.Email';
import ActionLabel from '@salesforce/label/c.Action';
import ViewLabel from '@salesforce/label/c.View';
import EditLabel from '@salesforce/label/c.Edit';

const actions = [
    { label: ViewLabel, name: 'view' },
    { label: EditLabel, name: 'edit' }
];
const columns = [
    {
    label: FirstNameLabel,
    fieldName: 'FirstName',
    type: 'text',
    sortable: true
    },
    {
    label: LastNameLabel,
    fieldName: 'LastName',
    sortable: true
    },
    {
    label: EmailLabel,
    fieldName: 'Email',
    sortable: true
    },
    {   
    label: ActionLabel,
    type: 'action',
    typeAttributes: { rowActions: actions }
    }
];

export default class ContactList extends NavigationMixin(LightningElement)  {
    columns = columns;
    items;
    error;
    searchKey = '';
    sortedBy =  "FirstName";
    sortedDirection = "asc" ;
   
    @wire(getContacts,{searchKey: '$searchKey', sortBy: '$sortedBy', sortDirection: '$sortedDirection'})
        wiredContacts({error, data}) {
                if (data) {
                    var resultData = JSON.parse(data);   
                    
                    if(resultData.error){   
                        this.error = resultData.error;
                        this.items = undefined;
                        this.displayError(this.error, 'Error', 'Error');
                    }else{
                        this.columns = columns; // setting columns of table
                        this.items = resultData.contacts; // setting data to table
                    }
                   this.error = undefined;
                } else if (error) {
                    this.error = error;
                    this.items = undefined;
                    this.displayError(this.error, 'Error', 'Error'); 
                }
        }
        searchContact(event ) { //method to perform search
            this.searchKey = event.target.value; //setting this reactive property 
        }
        handleAction( event ) { //method to handle edit and view action
 
            const actionName = event.detail.action.name;
            const record = event.detail.row;
            switch ( actionName ) {
                case 'view':
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: record.Id,
                            objectApiName: 'Contact',
                            actionName: 'view'
                        }
                    });
                    break;
                case 'edit':
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: record.Id,
                            objectApiName: 'Contact',
                            actionName: 'edit'
                        }
                    });
                    break;
                default:
            }
    }

    onSort(event) { // on sorting column
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        
    }
 
    displayError(message, variant, title) { // to display toast message
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
 
    
}