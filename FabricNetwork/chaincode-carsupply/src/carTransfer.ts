/*
 * SPDX-License-Identifier: Apache-2.0
 */
// Deterministic JSON.stringify()
import {Context, Contract, Info, Returns, Transaction} from 'fabric-contract-api';
import stringify from 'json-stringify-deterministic';
import sortKeysRecursive from 'sort-keys-recursive';


@Info({title: 'CarTransfer', description: 'Smart contract for trading cars'})
export class CarTransferContract extends Contract {

    // CreateCar issues a new car to the world state with given details.
    @Transaction()
    public async CreateCar(ctx: Context, serialNumber: string, owner: string, whellId: string, engineId: string, transmissionId: string, chassisId: string): Promise<string> {
        const exists = await this.CarExists(ctx, serialNumber);
        if (exists) {
            throw new Error(`The car ${serialNumber} already exists`);
        }

        const car = {
            docType: "Car",
            SerialNumber: serialNumber,
            Owner: owner,
            Status: "Created",
            WhellId: whellId,
            EngineId: engineId,
            TransmissionId: transmissionId,
            ChassisId: chassisId
        };
        // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
        await ctx.stub.putState(serialNumber, Buffer.from(stringify(sortKeysRecursive(car))));

        const updatedPartWhell = {
            docType: "PartCar",
            serialNumber: whellId,
            Owner: owner,
            Status: "Comsumed",
        }

        const updatedPartEngine = {
            docType: "PartCar",
            serialNumber: engineId,
            Owner: owner,
            Status: "Comsumed",
        }

        const updatedPartTransmission = {
            docType: "PartCar",
            serialNumber: transmissionId,
            Owner: owner,
            Status: "Comsumed",
        }

        const updatedPartChassis = {
            docType: "PartCar",
            serialNumber: chassisId,
            Owner: owner,
            Status: "Comsumed",
        }

        

        await ctx.stub.putState(whellId, Buffer.from(stringify(sortKeysRecursive(updatedPartWhell))));
        await ctx.stub.putState(engineId, Buffer.from(stringify(sortKeysRecursive(updatedPartEngine))));
        await ctx.stub.putState(transmissionId, Buffer.from(stringify(sortKeysRecursive(updatedPartTransmission))));
        await ctx.stub.putState(chassisId, Buffer.from(stringify(sortKeysRecursive(updatedPartChassis))));



        return "CreateCar Successfully"
    }

    // ReadCar returns the car stored in the world state with given id.
    @Transaction(false)
    public async ReadCar(ctx: Context, serialNumber: string): Promise<string> {
        const carJSON = await ctx.stub.getState(serialNumber); // get the car from chaincode state
        if (!carJSON || carJSON.length === 0) {
            throw new Error(`The car ${serialNumber} does not exist`);
        }
        return carJSON.toString();
    }

    @Transaction(false)
    public async ReadCarByOwner(ctx: Context, owner: string): Promise<string> {

        const allResults = [];
        const query = {
            selector: {
                docType: "Car",
                Owner: owner
            }
            }   
        // range query with empty string for startKey and endKey does an open-ended query of all cars in the chaincode namespace.
        const iterator = await ctx.stub.getQueryResult(JSON.stringify(query));
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }
        return JSON.stringify(allResults);

    }

    // UpdateCar updates an existing car in the world state with provided parameters.
    @Transaction()
    public async UpdateCar(ctx: Context, serialNumber: string, owner: string, status: string, whellId: string, engineId: string, transmissionId: string, chassisId: string): Promise<void> {
        const exists = await this.CarExists(ctx, serialNumber);
        if (!exists) {
            throw new Error(`The car ${serialNumber} does not exist`);
        }

        // overwriting original car with new car
        const updatedCar = {
            docType: "Car",
            SerialNumber: serialNumber,
            Owner: owner,
            Status: status,
            WhellId: whellId,
            EngineId: engineId,
            TransmissionId: transmissionId,
            ChassisId: chassisId

        };
        // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
        return ctx.stub.putState(serialNumber, Buffer.from(stringify(sortKeysRecursive(updatedCar))));
    }

    // DeleteCar deletes an given car from the world state.
    @Transaction()
    public async DeleteCar(ctx: Context, serialNumber: string): Promise<void> {
        const exists = await this.CarExists(ctx, serialNumber);
        if (!exists) {
            throw new Error(`The car ${serialNumber} does not exist`);
        }
        return ctx.stub.deleteState(serialNumber);
    }

    // CarExists returns true when car with given ID exists in world state.
    @Transaction(false)
    @Returns('boolean')
    public async CarExists(ctx: Context, SerialNumber: string): Promise<boolean> {
        const carJSON = await ctx.stub.getState(SerialNumber);
        return carJSON && carJSON.length > 0;
    }

    // TransferCar updates the owner field of car with given id in the world state, and returns the old owner.
    @Transaction()
    public async TransferCar(ctx: Context, serialNumber: string, newOwner: string): Promise<string> {
        const carString = await this.ReadCar(ctx, serialNumber);
        const car = JSON.parse(carString);
        const oldOwner = car.Owner;
        car.Owner = newOwner;
        car.Status = "Sold";
        // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
        await ctx.stub.putState(serialNumber, Buffer.from(stringify(sortKeysRecursive(car))));
        return "Transfer Successfully";
    }

    // GetAllCars returns all cars found in the world state.
    @Transaction(false)
    @Returns('string')
    public async GetAllCars(ctx: Context): Promise<string> {
        const allResults = [];
        // range query with empty string for startKey and endKey does an open-ended query of all cars in the chaincode namespace.

        const query = {
            selector: {
                docType: "Car"
            }
        }
        const iterator = await ctx.stub.getQueryResult(JSON.stringify(query));
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }
        return JSON.stringify(allResults);
    }

    @Transaction(false)
    @Returns('string')
    public async GetHistoryOfCar(ctx: Context, serialNumber: string): Promise<string> {
        const allResults = [];
        // range query with empty string for startKey and endKey does an open-ended query of all cars in the chaincode namespace.
        const iterator = await ctx.stub.getHistoryForKey(serialNumber);
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }
        return JSON.stringify(allResults);
    }

    @Transaction()
    public async CreatePart(ctx: Context, serialNumber: string, owner: string, status: string, partType: string): Promise<string> {
        const exists = await this.PartExist(ctx, serialNumber);
        if (exists) {
            throw new Error(`The car ${serialNumber} already exists`);
        }

        const part = {
            docType: "PartCar",
            SerialNumber: serialNumber,
            Owner: owner,
            Status: status,
            PartType: partType,
        };
        // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
        await ctx.stub.putState(serialNumber, Buffer.from(stringify(sortKeysRecursive(part))));
        return "Created Successfully"
    }

    // ReadPart returns the car stored in the world state with given id.
    @Transaction(false)
    public async ReadPart(ctx: Context, serialNumber: string): Promise<string> {
        const partJSON = await ctx.stub.getState(serialNumber); // get the car from chaincode state
        if (!partJSON || partJSON.length === 0) {
            throw new Error(`The car ${serialNumber} does not exist`);
        }
        return partJSON.toString();
    }

    @Transaction(false)
    public async ReadPartIsComsumed(ctx: Context): Promise<string> {

        const allResults = [];
        const query = {
            selector: {
                docType: "PartCar",
                Status: "Comsumed",
            }
            }   
        // range query with empty string for startKey and endKey does an open-ended query of all cars in the chaincode namespace.
        const iterator = await ctx.stub.getQueryResult(JSON.stringify(query));
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }
        return JSON.stringify(allResults);

    }

    // UpdateCar updates an existing car in the world state with provided parameters.
    @Transaction()
    public async UpdatePart(ctx: Context, serialNumber: string, owner: string, status: string, partType: string): Promise<void> {
        const exists = await this.PartExist(ctx, serialNumber);
        if (!exists) {
            throw new Error(`The car ${serialNumber} does not exist`);
        }

        // overwriting original car with new car
        const updatedPart = {
            docType: "PartCar",
            SerialNumber: serialNumber,
            Owner: owner,
            Status: status,
            PartType: partType,
        };
        // we insert data in alphabetic order using 'json-stringify-deterministic' and 'sort-keys-recursive'
        return ctx.stub.putState(serialNumber, Buffer.from(stringify(sortKeysRecursive(updatedPart))));
    }

    // DeleteCar deletes an given car from the world state.
    @Transaction()
    public async DeletePart(ctx: Context, serialNumber: string): Promise<void> {
        const exists = await this.PartExist(ctx, serialNumber);
        if (!exists) {
            throw new Error(`The car ${serialNumber} does not exist`);
        }
        return ctx.stub.deleteState(serialNumber);
    }

    // CarExists returns true when car with given ID exists in world state.
    @Transaction(false)
    @Returns('boolean')
    public async PartExist(ctx: Context, SerialNumber: string): Promise<boolean> {
        const partJSON = await ctx.stub.getState(SerialNumber);
        return partJSON && partJSON.length > 0;
    }

    // TransferCar updates the owner field of car with given id in the world state, and returns the old owner.

    // GetAllCars returns all cars found in the world state.
    @Transaction(false)
    @Returns('string')
    public async GetAllParts(ctx: Context): Promise<string> {
        const allResults = [];

        // range query with empty string for startKey and endKey does an open-ended query of all cars in the chaincode namespace.

        const query = {
            selector:{
                docType: 'partCar'
            }
        }
        const iterator = await ctx.stub.getQueryResult(JSON.stringify(query));
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }
        return JSON.stringify(allResults);
    }

    @Transaction(false)
    @Returns('string')
    public async GetHistoryOfPart(ctx: Context, serialNumber: string): Promise<string> {
        const allResults = [];
        // range query with empty string for startKey and endKey does an open-ended query of all cars in the chaincode namespace.
        const iterator = await ctx.stub.getHistoryForKey(serialNumber);
        let result = await iterator.next();
        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }
        return JSON.stringify(allResults);
    }

}

