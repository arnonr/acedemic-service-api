const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

const filterData = (req) => {
    let $where = {
        deleted_at: null,
    };

    if (req.query.id) {
        $where["id"] = parseInt(req.query.id);
    }

    if (req.query.serve_id) {
        $where["serve_id"] = parseInt(req.query.serve_id);
    }

    if (req.query.lang && req.query.lang == "en") {
        $where["name_en"] = {
            not: null,
        };
    }

    if (req.query.name_th) {
        $where["name_th"] = {
            contains: req.query.name_th,
            //   mode: "insensitive",
        };
    }

    if (req.query.name_en) {
        $where["name_en"] = {
            contains: req.query.name_en,
            //   mode: "insensitive",
        };
    }

    if (req.query.name) {
        if (req.query.lang && req.query.lang == "th") {
            $where["name_th"] = {
                contains: req.query.name,
            };
        } else {
            $where["name_en"]["contains"] = req.query.name;
        }
    }

    if (req.query.is_publish) {
        $where["is_publish"] = parseInt(req.query.is_publish);
    }

    return $where;
};

// หาจำนวนทั้งหมดและลำดับ
const countDataAndOrder = async (req, $where) => {
    //   Order
    let $orderBy = {};
    if (req.query.orderBy) {
        $orderBy[req.query.orderBy] = req.query.order;
    } else {
        $orderBy = { created_at: "asc" };
    }

    //Count
    let $count = await prisma.test_type.findMany({
        where: $where,
    });

    $count = $count.length;
    let $perPage = req.query.perPage ? Number(req.query.perPage) : 20;
    let $currentPage = req.query.currentPage
        ? Number(req.query.currentPage)
        : 1;
    let $totalPage =
        Math.ceil($count / $perPage) == 0 ? 1 : Math.ceil($count / $perPage);
    let $offset = $perPage * ($currentPage - 1);

    return {
        $orderBy: $orderBy,
        $offset: $offset,
        $perPage: $perPage,
        $count: $count,
        $totalPage: $totalPage,
        $currentPage: $currentPage,
    };
};

// ฟิลด์ที่ต้องการ Select รวมถึง join
const selectField = {
    id: true,
    name_th: true,
    name_en: true,
    detail_th: true,
    detail_en: true,
    is_publish: true,
    price1: true,
    price2: true,
    price3: true,
    price4: true,
    price5: true,
    unit_th: true,
    serve_id: true,
};

const checkLanguage = (req) => {
    let prismaLang = prisma.$extends({
        result: {
            type: {
                name: {
                    needs: { name_th: true },
                    compute(table) {
                        return req.query.lang && req.query.lang == "en"
                            ? table.name_en
                            : table.name_th;
                    },
                },
                detail: {
                    needs: { detail_th: true },
                    compute(table) {
                        return req.query.lang && req.query.lang == "en"
                            ? table.detail_en
                            : table.detail_th;
                    },
                },
            },
        },
    });

    return prismaLang;
};

const cutFroala = (detail) => {
    let detail_success =
        detail != null
            ? detail
                  .replaceAll("Powered by", "")
                  .replaceAll(
                      '<p data-f-id="pbf" style="text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;">',
                      ""
                  )
                  .replaceAll(
                      '<a href="https://www.froala.com/wysiwyg-editor?pb=1" title="Froala Editor">',
                      ""
                  )
                  .replaceAll("Froala Editor</a></p>", "")
            : undefined;
    return detail_success;
};

const methods = {
    async onGetAll(req, res) {
        try {
            let $where = filterData(req);
            let other = await countDataAndOrder(req, $where);

            const item = await prisma.test_type.findMany({
                select: selectField,
                where: $where,
                orderBy: other.$orderBy,
                skip: other.$offset,
                take: other.$perPage,
            });

            res.status(200).json({
                data: item,
                totalData: other.$count,
                totalPage: other.$totalPage,
                currentPage: other.$currentPage,
                lang: req.query.lang ? req.query.lang : "",
                msg: " success",
            });
        } catch (error) {
            res.status(500).json({ msg: error.message });
        }
    },

    async onGetById(req, res) {
        try {
            let prismaLang = checkLanguage(req);
            const item = await prismaLang.test_type.findUnique({
                select: selectField,
                where: {
                    id: Number(req.params.id),
                },
            });

            res.status(200).json({
                data: item,
                msg: " success",
            });
        } catch (error) {
            res.status(404).json({ msg: error.message });
        }
    },

    // สร้าง
    async onCreate(req, res) {
        try {
            const item = await prisma.test_type.create({
                data: {
                    name_th: req.body.name_th,
                    name_en: req.body.name_en,
                    detail_th:
                        req.body.detail_th != null
                            ? cutFroala(req.body.detail_th)
                            : undefined,
                    detail_en:
                        req.body.detail_en != null
                            ? cutFroala(req.body.detail_en)
                            : undefined,
                    price1:
                        req.body.price1 != "" ? Number(req.body.price1) : null,
                    price2:
                        req.body.price2 != "" ? Number(req.body.price2) : null,
                    price3:
                        req.body.price3 != "" ? Number(req.body.price3) : null,
                    price4:
                        req.body.price4 != "" ? Number(req.body.price4) : null,
                    price5:
                        req.body.price5 != "" ? Number(req.body.price5) : null,
                    serve_id:
                        req.body.serve_id != ""
                            ? Number(req.body.serve_id)
                            : null,
                    unit_th:
                        req.body.unit_th != null ? req.body.unit_th : undefined,
                    level: req.body.level ? Number(req.body.level) : null,
                    is_publish: Number(req.body.is_publish),
                    created_by: "arnonr",
                    updated_by: "arnonr",
                },
            });

            res.status(201).json({ ...item, msg: "success" });
        } catch (error) {
            res.status(400).json({ msg: error.message });
        }
    },

    // แก้ไข
    async onUpdate(req, res) {
        try {
            const item = await prisma.test_type.update({
                where: {
                    id: Number(req.params.id),
                },
                data: {
                    name_th:
                        req.body.name_th != null ? req.body.name_th : undefined,
                    name_en:
                        req.body.name_en != null ? req.body.name_en : undefined,
                    detail_th:
                        req.body.detail_th != null
                            ? cutFroala(req.body.detail_th)
                            : undefined,
                    detail_en:
                        req.body.detail_en != null
                            ? cutFroala(req.body.detail_en)
                            : undefined,
                    price1:
                        req.body.price1 != "" ? Number(req.body.price1) : null,
                    price2:
                        req.body.price2 != "" ? Number(req.body.price2) : null,
                    price3:
                        req.body.price3 != "" ? Number(req.body.price3) : null,
                    price4:
                        req.body.price4 != "" ? Number(req.body.price4) : null,
                    price5:
                        req.body.price5 != "" ? Number(req.body.price5) : null,
                    unit_th:
                        req.body.unit_th != null ? req.body.unit_th : undefined,
                    serve_id:
                        req.body.serve_id != ""
                            ? Number(req.body.serve_id)
                            : undefined,
                    level:
                        req.body.level != null
                            ? Number(req.body.level)
                            : undefined,
                    is_publish: Number(req.body.is_publish),
                    updated_by: "arnonr",
                },
            });

            res.status(200).json({ ...item, msg: "success" });
        } catch (error) {
            res.status(400).json({ msg: error.message });
        }
    },
    // ลบ
    async onDelete(req, res) {
        try {
            await prisma.test_type.update({
                where: {
                    id: Number(req.params.id),
                },
                data: {
                    deleted_at: new Date().toISOString(),
                },
            });

            res.status(200).json({
                msg: "success",
            });
        } catch (error) {
            res.status(400).json({ msg: error.message });
        }
    },

    async onDeleteWithServe(req, res) {
        try {
            await prisma.test_type.deleteMany({
                where: {
                    serve_id: Number(req.params.id),
                },
            });

            res.status(200).json({
                msg: "success",
            });
        } catch (error) {
            res.status(400).json({ msg: error.message });
        }
    },
};

module.exports = { ...methods };
