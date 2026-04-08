import * as admin from "firebase-admin";
import { setGlobalOptions } from "firebase-functions";

admin.initializeApp();

setGlobalOptions({ maxInstances: 10 });

export { generateMorningBriefScheduled, triggerMorningBrief } from "./generate-morning-brief";
export { morningBriefs } from "./api-morning-briefs";

// Epic 3: Feedback & Accuracy
export { feedback } from "./api-feedback";
export { accuracy } from "./api-accuracy";
export { evaluateAccuracyScheduled, triggerAccuracyEvaluation } from "./accuracy-tracker";
