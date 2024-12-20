const express = require("express");
const router = express.Router();

const controllers = require("../../controllers/TestTypeController");
const auth = require("../auth");
// const { checkPermission } = require("../accessControl");

router.get("/", controllers.onGetAll);
router.get("/:id", controllers.onGetById);

router.post(
    "/",
    // auth.required,
    controllers.onCreate
);

router.put(
    "/:id",
    // auth.required,
    controllers.onUpdate
);

router.delete(
    "/:id",
    //   auth.required,
    controllers.onDelete
);

router.delete(
    "/delete-with-serve/:id",
    //   auth.required,
    controllers.onDeleteWithServe
);




module.exports = router;
