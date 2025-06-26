module.exports = cds.service.impl(async function () {
    // It will look out CatalogService.cds file and get the object of the corresponding
    // entity so that we can tell capm which entity I want to add generic handler
    const { EmployeeSet, POSet } = this.entities;

    // Validation
    this.before(['UPDATE', 'CREATE'], EmployeeSet, (req, res) => {
        // console.log("testing " + JSON.stringify(req.data));
        var jsonData = req.data;
        if (jsonData.hasOwnProperty("salaryAmount")) {
            const salary = req.data.salaryAmount;
            if (salary > 1000000) {
                req.error(500, "Salary is too high!");
            }
        }
    })

    this.after('READ', EmployeeSet, (req, res) => {
        // console.log(JSON.stringify(req.data));
        console.log(JSON.stringify(res));
        res.results.push({
            "ID": "dummy",
            "nameFirst": "Michel",
            "nameLast": "Saylor"
        })
    })

    // Implement Function - Non Instance Bound
    this.on('getMostExpensiveOrder', async (req, res) => {
        try {
            const tx = cds.tx(req);
            const myData = await tx.read(POSet).orderBy({
                "GROSS_AMOUNT": 'desc'
            }).limit(1);
            return myData;
        } catch (error) {
            return 'Error ' + error.toString();
        }
    })

    this.on('getOrderDefault', async (req, res) => {
        try {
            return { OVERALL_STATUS: 'N' }
        } catch (error) {
            return 'Error ' + error.toString();
        }
    })

    // Implement Action - Instance Bound
    this.on('boost', async (req, res) => {
        try {
            // Security
            req.user.is('Editor') || req.reject(403);
            const POID = req.params[0];
            console.log("PO ID is " + JSON.stringify(POID));
            const tx = cds.tx(req);
            await tx.update(POSet).with({
                "GROSS_AMOUNT": { '+=': 20000 }
            }).where({ ID: POID });

            const reply = tx.read(POSet).where({ ID: POID });
            return reply;
        } catch (error) {
            return 'Error ' + error.toString();
        }
    })

    this.on('setDelivered', async (req, res) => {
        try {
            // Security
            const POID = req.params[0];
            console.log("PO ID is " + JSON.stringify(POID));
            const tx = cds.tx(req);
            await tx.update(POSet).with({
                "OVERALL_STATUS": 'D'
            }).where({ ID: POID });

            const reply = tx.read(POSet).where({ ID: POID });
            return reply;
        } catch (error) {
            return 'Error ' + error.toString();
        }
    })
})