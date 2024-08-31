export class BabysitterAlreadyAssigned extends Error {
    constructor(message = "BabysitterAlreadyAssigned error") {
        super(message);
        this.name = "BabysitterAlreadyAssignedError";
    }
}