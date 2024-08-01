var path = require("path");
const sharp = require("sharp");

const methods = {
    async onUploadFile(req, real_path, attribute_name, w = undefined, h = undefined) {
        try {
            //
            let pathFile = null;

            if (!req.files || Object.keys(req.files).length === 0) {
            } else {
                let uploadFile = req.files[attribute_name];
                let typeFile = uploadFile.mimetype.split("/");
                let d = new Date();
                let date =
                    d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate();
                let nameFile = date + "-t-" + Date.now() + "." + typeFile[1];

                let pathUpload = path.resolve(
                    __dirname + "/../public/uploads" + real_path + nameFile
                );

                /* Resize and save to path */
                sharp(uploadFile.data.buffer)
                    .resize(w, h)
                    .toFile(pathUpload, (err, info) => {
                        // console.log(info);
                        if (err) return err;
                    });

                // uploadFile.mv(pathUpload, function (err) {
                //     if (err) return err;
                // });
                pathFile = real_path + nameFile;
            }
            return pathFile;
        } catch (error) {
            return "error";
        }
    },
};

module.exports = { ...methods };