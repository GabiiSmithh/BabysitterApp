export class Service {
    constructor({
        id,
        babysitterId,
        tutorId,
        startDate,
        endDate,
        value,
        childrenCount,
        address,
    }) {
        this.id = id;
        this.babysitterId = babysitterId;
        this.tutorId = tutorId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.value = value;
        this.childrenCount = childrenCount;
        this.address = address;
    }
}