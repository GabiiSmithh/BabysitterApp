export class Service {
    constructor({
        id,
        babysitterId,
        babysitterName,
        tutorId,
        tutorName,
        startDate,
        endDate,
        value,
        childrenCount,
        address,
    }) {
        this.id = id;
        this.babysitterId = babysitterId;
        this.babysitterName = babysitterName;
        this.tutorId = tutorId;
        this.tutorName = tutorName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.value = value;
        this.childrenCount = childrenCount;
        this.address = address;
    }
}