/*
  SPDX-License-Identifier: Apache-2.0
*/

import {Object, Property} from 'fabric-contract-api';

@Object()
export class Car {
    @Property()
    public docType: string;
    @Property()
    public SerialNumber: string;

    @Property()
    public Owner: string;

    @Property()
    public Status: string;

    @Property()
    public WheelId: string ;
    @Property()
    public EngineId: string ;
    @Property()
    public TransmissionId: string ;
    @Property()
    public ChassisId: string ;

}
