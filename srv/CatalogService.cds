using {
    mycapapp.db.master,
    mycapapp.db.transaction
} from '../db/data-model';

using {mycapapp.myviews} from '../db/CDSViews';


service CatalogService @(
    path    : 'CatalogService',
    requires: 'authenticated-user'
) {
    // Entityset which offers all the GET, PUT, POST, DELETE
    entity EmployeeSet @(restrict: [
        {
            grant: ['READ'],
            to   : 'Display',
            where: 'bankName = $user.BankName'
        },
        {
            grant: ['WRITE'],
            to   : 'Edit'
        }
    ])                        as projection on master.employees;

    entity BusinessPartnerSet as projection on master.businesspartner;

    entity AddressSet @(restrict: [{
        grant: ['READ'],
        to   : 'Display',
        where: 'COUNTRY = $user.Country'
    }])                       as projection on master.address;

    entity POSet @(
        odata.draft.enabled         : true,
        Common.DefaultValuesFunction: 'getOrderDefault'
    )                         as
        projection on transaction.purchaseorder {
            *,
            case OVERALL_STATUS
                when
                    'A'
                then
                    'Approved'
                when
                    'X'
                then
                    'Rejected'
                when
                    'N'
                then
                    'New'
                when
                    'D'
                then
                    'Delivered'
                else
                    'Pending'
            end as OverallStatusText : String(10),
            case OVERALL_STATUS
                when
                    'A'
                then
                    3
                when
                    'D'
                then
                    3
                when
                    'X'
                then
                    1
                when
                    'N'
                then
                    2
                else
                    2
            end as IconColor         : Integer
        }
        actions {
            action boost() returns POSet;
            action setDelivered() returns POSet;
        };

    entity POItemSet          as projection on transaction.poitems;
    // Expose CDS Entity
    entity ProductSet         as projection on myviews.CDSViews.ProductView;
    // Non-Instance Bound Function - If you want multiple records use array of
    function getMostExpensiveOrder() returns POSet;
    function getOrderDefault()       returns POSet;
}
