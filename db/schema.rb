# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160308005205) do

  create_table "cooperations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cooperationable_id"
    t.string   "cooperationable_type"
    t.decimal  "ratio"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "cooperations", ["user_id"], name: "index_cooperations_on_user_id"

  create_table "department_users", force: :cascade do |t|
    t.integer  "department_id"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "role"
  end

  add_index "department_users", ["department_id"], name: "index_department_users_on_department_id"
  add_index "department_users", ["user_id"], name: "index_department_users_on_user_id"

  create_table "departments", force: :cascade do |t|
    t.integer  "sup_department_id"
    t.string   "name"
    t.boolean  "parent"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "departments", ["sup_department_id"], name: "index_departments_on_sup_department_id"

  create_table "modifications", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "scale"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "investment_manager"
    t.decimal  "management_fee"
    t.decimal  "rate"
    t.decimal  "fee"
    t.text     "notes"
    t.string   "modificationable_type"
    t.integer  "modificationable_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "annual"
    t.string   "risk"
  end

  add_index "modifications", ["user_id"], name: "index_modifications_on_user_id"

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string   "number"
    t.string   "name"
    t.string   "plan_type"
    t.decimal  "scale"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "management_fee"
    t.string   "investment_manager"
    t.integer  "department_id"
    t.decimal  "rate"
    t.decimal  "fee"
    t.integer  "user_id"
    t.string   "parter"
    t.text     "notes"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "annual"
    t.string   "risk"
  end

  add_index "plans", ["department_id"], name: "index_plans_on_department_id"
  add_index "plans", ["user_id"], name: "index_plans_on_user_id"

  create_table "projects", force: :cascade do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.string   "number"
    t.string   "name"
    t.decimal  "scale"
    t.decimal  "asset_price"
    t.decimal  "pool_price"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "management_fee"
    t.string   "investment_manager"
    t.string   "parter"
    t.integer  "department_id"
    t.decimal  "rate"
    t.decimal  "fee"
    t.text     "notes"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "annual"
    t.string   "risk"
  end

  add_index "projects", ["department_id"], name: "index_projects_on_department_id"
  add_index "projects", ["plan_id"], name: "index_projects_on_plan_id"
  add_index "projects", ["user_id"], name: "index_projects_on_user_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "father_id"
    t.integer  "son_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "relationships", ["father_id"], name: "index_relationships_on_father_id"
  add_index "relationships", ["person_id"], name: "index_relationships_on_person_id"
  add_index "relationships", ["son_id"], name: "index_relationships_on_son_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

  create_table "tasks", force: :cascade do |t|
    t.string   "name"
    t.string   "task_type"
    t.decimal  "amount"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "description"
    t.string   "taskable_type"
    t.integer  "taskable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "usertype"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
