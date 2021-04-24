# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_24_111409) do

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "auth_tokens", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["user_id", "active"], name: "index_auth_tokens_on_user_id_and_active"
    t.index ["user_id"], name: "fk_rails_0d66c22f4c"
  end

  create_table "badges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type", null: false
    t.string "name", null: false
    t.string "rarity", null: false
    t.string "icon", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_badges_on_name", unique: true
    t.index ["type"], name: "index_badges_on_type", unique: true
  end

<<<<<<< HEAD
  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
=======
  create_table "blog_comments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blog_post_id", null: false
    t.bigint "user_id", null: false
    t.bigint "blog_comment_id"
    t.text "content", size: :long, null: false
    t.text "html", size: :long, null: false
    t.boolean "edited", default: false, null: false
    t.text "previous_content"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_comment_id"], name: "fk_rails_de25ffa957"
    t.index ["blog_post_id"], name: "fk_rails_ccd98ed6ee"
    t.index ["user_id"], name: "fk_rails_a2e6f28c3a"
  end

  create_table "blog_posts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "slug", null: false
    t.string "category", null: false
    t.datetime "published_at", null: false
    t.string "title", null: false
    t.string "author_handle", null: false
    t.string "marketing_copy", limit: 280
    t.string "content_repository", null: false
    t.string "content_filepath", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["published_at"], name: "index_blog_posts_on_published_at"
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
  end

  create_table "bug_reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content_markdown", null: false
    t.text "content_html", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_bug_reports_on_user_id"
  end

  create_table "changelog_entries", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "created_by_id", null: false
    t.string "title", null: false
    t.text "details_markdown"
    t.string "referenceable_type"
    t.bigint "referenceable_id"
    t.string "info_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.text "details_html"
    t.string "referenceable_key"
    t.index ["created_by_id"], name: "index_changelog_entries_on_created_by_id"
    t.index ["referenceable_type", "referenceable_id"], name: "index_changelog_entries_on_referenceable"
  end

  create_table "changelog_entry_tweets", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "changelog_entry_id", null: false
    t.text "copy", null: false
    t.integer "status", default: 0, null: false
    t.index ["changelog_entry_id"], name: "index_changelog_entry_tweets_on_changelog_entry_id"
  end

  create_table "communication_preferences", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "email_on_new_discussion_post", default: true, null: false
    t.boolean "email_on_new_discussion_post_for_mentor", default: true, null: false
    t.boolean "email_on_new_iteration_for_mentor", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "receive_product_updates", default: true, null: false
    t.boolean "email_on_solution_approved", default: true, null: false
    t.boolean "email_on_remind_mentor", default: true, null: false
    t.boolean "email_on_new_solution_comment_for_solution_user", default: true, null: false
    t.boolean "email_on_new_solution_comment_for_other_commenter", default: true, null: false
    t.boolean "email_on_mentor_heartbeat", default: true, null: false
    t.string "token"
    t.boolean "email_on_remind_about_solution", default: true, null: false
    t.index ["token"], name: "index_communication_preferences_on_token"
    t.index ["user_id"], name: "fk_rails_65642a5510"
  end

  create_table "contributors", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "github_username", null: false
    t.string "avatar_url", null: false
    t.integer "num_contributions", default: 0, null: false
    t.boolean "is_maintainer", default: false, null: false
    t.boolean "is_core", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "github_id", null: false
    t.index ["is_maintainer", "is_core", "num_contributions"], name: "main_find_idx"
  end

  create_table "delayed_jobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "track_id"
    t.string "section", null: false
    t.string "slug", null: false
    t.string "git_repo", null: false
    t.string "git_path", null: false
    t.string "title", null: false
    t.string "nav_title"
    t.string "blurb"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_documents_on_slug"
    t.index ["track_id"], name: "index_documents_on_track_id"
    t.index ["uuid"], name: "index_documents_on_uuid", unique: true
  end

  create_table "exercise_authorships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id", "user_id"], name: "index_exercise_authorships_on_exercise_id_and_user_id", unique: true
    t.index ["exercise_id"], name: "index_exercise_authorships_on_exercise_id"
    t.index ["user_id"], name: "index_exercise_authorships_on_user_id"
  end

  create_table "exercise_contributorships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id", "user_id"], name: "index_exercise_contributorships_on_exercise_id_and_user_id", unique: true
    t.index ["exercise_id"], name: "index_exercise_contributorships_on_exercise_id"
    t.index ["user_id"], name: "index_exercise_contributorships_on_user_id"
  end

  create_table "exercise_fixtures", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "comments_by_id", null: false
    t.text "representation", null: false
    t.string "representation_hash", null: false
    t.string "status", null: false
    t.text "comments_markdown", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id", "representation_hash"], name: "index_exercise_fixtures_on_exercise_id_and_representation_hash", unique: true
  end

  create_table "exercise_practiced_concepts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "track_concept_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id", "track_concept_id"], name: "uniq", unique: true
    t.index ["exercise_id"], name: "index_exercise_practiced_concepts_on_exercise_id"
    t.index ["track_concept_id"], name: "index_exercise_practiced_concepts_on_track_concept_id"
  end

  create_table "exercise_prerequisites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "track_concept_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id", "track_concept_id"], name: "uniq", unique: true
    t.index ["exercise_id"], name: "index_exercise_prerequisites_on_exercise_id"
    t.index ["track_concept_id"], name: "index_exercise_prerequisites_on_track_concept_id"
  end

  create_table "exercise_representations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "source_submission_id", null: false
    t.text "ast", null: false
    t.string "ast_digest", null: false
    t.json "mapping"
    t.integer "feedback_type", limit: 1
    t.text "feedback_markdown"
    t.text "feedback_html"
    t.bigint "feedback_author_id"
    t.bigint "feedback_editor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id", "ast_digest"], name: "exercise_representations_unique", unique: true
    t.index ["exercise_id"], name: "index_exercise_representations_on_exercise_id"
    t.index ["feedback_author_id"], name: "index_exercise_representations_on_feedback_author_id"
    t.index ["feedback_editor_id"], name: "index_exercise_representations_on_feedback_editor_id"
    t.index ["source_submission_id"], name: "index_exercise_representations_on_source_submission_id"
  end

  create_table "exercise_taught_concepts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "track_concept_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id", "track_concept_id"], name: "uniq", unique: true
    t.index ["exercise_id"], name: "index_exercise_taught_concepts_on_exercise_id"
    t.index ["track_concept_id"], name: "index_exercise_taught_concepts_on_track_concept_id"
  end

  create_table "exercise_topics", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "exercise_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "fk_rails_0e58b87007"
    t.index ["topic_id"], name: "fk_rails_0e642b953e"
  end

  create_table "exercises", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.string "uuid", null: false
    t.string "slug", null: false
    t.string "title", null: false
<<<<<<< HEAD
    t.string "blurb", limit: 350
    t.integer "difficulty", limit: 1, default: 1, null: false
=======
    t.boolean "deprecated", default: true, null: false
    t.text "blurb"
    t.integer "difficulty", default: 1, null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "median_wait_time"
    t.string "type", null: false
>>>>>>> 21929105 (Continue ETL work)
    t.string "git_sha", null: false
    t.string "synced_to_git_sha", null: false
<<<<<<< HEAD
    t.integer "position", null: false
    t.boolean "deprecated", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["track_id", "uuid"], name: "index_exercises_on_track_id_and_uuid", unique: true
    t.index ["track_id"], name: "index_exercises_on_track_id"
    t.index ["uuid"], name: "index_exercises_on_uuid"
=======
    t.index ["track_id"], name: "fk_rails_a796d89c21"
    t.index ["uuid"], name: "index_exercises_on_uuid", unique: true
  end

  create_table "flipper_features", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "friendly_id_slugs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "slug", limit: 190, null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope", limit: 190
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "github_organization_members", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username", null: false
    t.boolean "alumnus", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_github_organization_members_on_username", unique: true
  end

  create_table "github_pull_request_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "github_pull_request_id", null: false
    t.string "node_id", null: false
    t.string "reviewer_username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["github_pull_request_id"], name: "index_github_pull_request_reviews_on_github_pull_request_id"
    t.index ["node_id"], name: "index_github_pull_request_reviews_on_node_id", unique: true
  end

  create_table "github_pull_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "node_id", null: false
    t.integer "number", null: false
    t.string "repo", null: false
    t.string "author_username"
    t.string "merged_by_username"
    t.string "title"
    t.json "data", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["node_id"], name: "index_github_pull_requests_on_node_id", unique: true
  end

  create_table "ignored_solution_mentorships", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id"], name: "fk_rails_31331ef022"
    t.index ["user_id"], name: "fk_rails_7b8f6c3112"
  end

  create_table "infrastructure_test_runner_versions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "test_runner_id", null: false
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_infrastructure_test_runner_versions_on_slug", unique: true
    t.index ["test_runner_id"], name: "fk_rails_63c05336de"
  end

  create_table "infrastructure_test_runners", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "language_slug", null: false
    t.integer "timeout_ms", null: false
    t.string "version_slug"
    t.integer "num_processors", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "iteration_analyses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "iteration_id", null: false
    t.string "ops_status", null: false
    t.json "analysis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "website_error"
    t.string "analysis_status"
    t.index ["iteration_id"], name: "fk_rails_c60c42383b"
  end

  create_table "iterations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "solution_type", default: "Solution", null: false
    t.string "legacy_uuid"
    t.bigint "submission_id", null: false
    t.string "uuid", null: false
    t.integer "idx", limit: 1, null: false
    t.boolean "published", default: false
    t.string "snippet", limit: 1500
    t.index ["solution_id"], name: "fk_rails_5d9f1bf4bd"
  end

  create_table "maintainers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "user_id"
    t.string "name", null: false
    t.string "avatar_url", null: false
    t.string "github_username", null: false
    t.string "link_text"
    t.string "link_url"
    t.text "bio"
    t.boolean "visible", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "alumnus"
    t.index ["track_id"], name: "fk_rails_ed46fd11a4"
    t.index ["user_id"], name: "fk_rails_5b1168410c"
  end

  create_table "mentor_discussion_posts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "discussion_id", null: false
    t.bigint "iteration_id", null: false
    t.bigint "user_id", null: false
    t.text "content_markdown", null: false
    t.text "content_html", null: false
    t.boolean "seen_by_student", default: false, null: false
    t.boolean "seen_by_mentor", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discussion_id"], name: "index_mentor_discussion_posts_on_discussion_id"
    t.index ["iteration_id"], name: "index_mentor_discussion_posts_on_iteration_id"
    t.index ["user_id"], name: "index_mentor_discussion_posts_on_user_id"
  end

  create_table "mentor_discussions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "mentor_id", null: false
    t.bigint "solution_id", null: false
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "awaiting_mentor_since"
    t.datetime "mentor_reminder_sent_at"
    t.string "uuid", null: false
    t.datetime "requires_student_action_since"
    t.datetime "awaiting_student_since"
    t.bigint "request_id"
    t.integer "status", limit: 1, default: 0, null: false
    t.integer "rating", limit: 1
    t.datetime "awaiting_student_since"
    t.datetime "awaiting_mentor_since"
    t.datetime "finished_at"
    t.integer "finished_by", limit: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mentor_id"], name: "index_mentor_discussions_on_mentor_id"
    t.index ["request_id"], name: "index_mentor_discussions_on_request_id"
    t.index ["solution_id"], name: "index_mentor_discussions_on_solution_id"
    t.datetime "mentor_finished_at"
    t.datetime "student_finished_at"
    t.index ["mentor_id"], name: "fk_rails_578676d431"
    t.index ["request_id"], name: "fk_rails_38162d0a13"
    t.index ["solution_id"], name: "fk_rails_704ccdde73"
    t.index ["uuid"], name: "index_mentor_discussions_on_uuid", unique: true
  end

  create_table "mentor_profiles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "average_rating", precision: 3, scale: 2
    t.integer "num_solutions_mentored", default: 0, null: false
    t.index ["user_id"], name: "fk_rails_9a3e3e5b86"
  end

  create_table "mentor_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "solution_id", null: false
    t.integer "status", limit: 1, default: 0, null: false
    t.text "comment_markdown", null: false
    t.text "comment_html", null: false
    t.bigint "locked_by_id"
    t.datetime "locked_until"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["locked_by_id"], name: "index_mentor_requests_on_locked_by_id"
    t.index ["solution_id"], name: "index_mentor_requests_on_solution_id"
  end

  create_table "mentor_student_relationships", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mentor_id", null: false
    t.bigint "student_id", null: false
    t.boolean "favorited", default: false, null: false
    t.boolean "blocked_by_mentor", default: false, null: false
    t.boolean "blocked_by_student", default: false, null: false
    t.integer "num_discussions", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mentor_id", "student_id"], name: "index_mentor_student_relationships_on_mentor_id_and_student_id", unique: true
    t.index ["mentor_id"], name: "index_mentor_student_relationships_on_mentor_id"
    t.index ["student_id"], name: "index_mentor_student_relationships_on_student_id"
  end

  create_table "mentor_testimonials", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "mentor_id", null: false
    t.bigint "student_id", null: false
    t.bigint "discussion_id", null: false
    t.string "uuid", null: false
    t.text "content", null: false
    t.boolean "revealed", default: false, null: false
    t.boolean "published", default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discussion_id"], name: "index_mentor_testimonials_on_discussion_id", unique: true
    t.index ["mentor_id"], name: "index_mentor_testimonials_on_mentor_id"
    t.index ["student_id"], name: "index_mentor_testimonials_on_student_id"
    t.index ["uuid"], name: "index_mentor_testimonials_on_uuid"
  end

<<<<<<< HEAD
  create_table "problem_reports", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "track_id"
    t.bigint "exercise_id"
    t.string "about_type"
    t.bigint "about_id"
    t.integer "type", limit: 1, default: 0, null: false
    t.text "content_markdown", null: false
    t.text "content_html", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["about_type", "about_id"], name: "index_problem_reports_on_about"
    t.index ["exercise_id"], name: "index_problem_reports_on_exercise_id"
    t.index ["track_id"], name: "index_problem_reports_on_track_id"
    t.index ["user_id"], name: "index_problem_reports_on_user_id"
  end

  create_table "scratchpad_pages", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
=======
  create_table "mentors", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.string "name", null: false
    t.string "avatar_url"
    t.string "github_username", null: false
    t.string "link_text"
    t.string "link_url"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "index_mentors_on_track_id"
  end

  create_table "reactions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "user_id", null: false
    t.integer "emotion", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id"], name: "fk_rails_51c7d8b8ad"
    t.index ["user_id"], name: "fk_rails_9f02fc96a0"
  end

  create_table "repo_update_fetches", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.timestamp "completed_at"
    t.bigint "repo_update_id", null: false
    t.string "host", limit: 190, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repo_update_id", "host"], name: "index_repo_update_fetches_on_repo_update_id_and_host", unique: true
    t.index ["repo_update_id"], name: "index_repo_update_fetches_on_repo_update_id"
  end

  create_table "repo_updates", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.timestamp "synced_at"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "research_experiment_solutions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "experiment_id", null: false
    t.string "uuid", null: false
    t.bigint "exercise_id", null: false
    t.string "git_sha", null: false
    t.string "git_slug", null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "difficulty_rating"
    t.index ["exercise_id"], name: "fk_rails_1be696c295"
    t.index ["experiment_id"], name: "fk_rails_8f6bde7fee"
    t.index ["user_id", "experiment_id", "exercise_id"], name: "research_solutions_uniq", unique: true
  end

  create_table "research_experiments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.string "repo_url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_research_experiments_on_slug"
  end

  create_table "research_user_experiments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "experiment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "survey"
    t.index ["experiment_id"], name: "fk_rails_809b029224"
    t.index ["user_id", "experiment_id"], name: "index_research_user_experiments_on_user_id_and_experiment_id", unique: true
  end

  create_table "scratchpad_pages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "about_type", null: false
    t.bigint "about_id", null: false
    t.bigint "user_id", null: false
    t.text "content_markdown", null: false
    t.text "content_html", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["about_type", "about_id"], name: "index_scratchpad_pages_on_about"
    t.index ["user_id"], name: "index_scratchpad_pages_on_user_id"
  end

  create_table "solution_comments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "user_id", null: false
    t.text "content", size: :long, null: false
    t.text "html", size: :long, null: false
    t.boolean "edited", default: false, null: false
    t.text "previous_content"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solution_locks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "user_id", null: false
    t.datetime "locked_until", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id"], name: "fk_rails_d2575804da"
    t.index ["user_id"], name: "fk_rails_7c200d25d8"
  end

  create_table "solution_stars", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solution_id", "user_id"], name: "index_solution_stars_on_solution_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_solution_stars_on_user_id"
  end

  create_table "solutions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "uuid", null: false
    t.bigint "exercise_id", null: false
    t.string "git_sha", null: false
    t.string "git_slug", null: false
    t.datetime "downloaded_at"
    t.datetime "completed_at"
    t.datetime "published_at"
    t.integer "num_reactions", default: 0, null: false
    t.text "reflection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show_on_profile", default: false, null: false
    t.boolean "allow_comments", default: false, null: false
    t.integer "num_comments", limit: 2, default: 0, null: false
    t.integer "num_stars", limit: 2, default: 0, null: false
    t.datetime "reminder_sent_at"
    t.string "type", null: false
    t.integer "status", limit: 1, default: 0, null: false
    t.string "iteration_status"
    t.integer "mentoring_status", limit: 1, default: 0, null: false
    t.string "snippet", limit: 1500
    t.integer "num_iterations", limit: 1, default: 0, null: false
    t.index ["completed_at", "id"], name: "ihid_fix_8"
    t.index ["created_at", "exercise_id"], name: "mentor_selection_idx_1"
    t.index ["created_at", "exercise_id"], name: "mentor_selection_idx_2"
    t.index ["exercise_id", "completed_at", "id"], name: "ihid_fix_11"
    t.index ["exercise_id", "completed_at", "id"], name: "mentor_selection_idx_3"
    t.index ["exercise_id", "id", "completed_at"], name: "ihid_fix_10"
    t.index ["exercise_id", "user_id"], name: "index_solutions_on_exercise_id_and_user_id", unique: true
    t.index ["exercise_id"], name: "fk_rails_8c0841e614"
    t.index ["id", "completed_at"], name: "ihid_fix_9"
    t.index ["user_id"], name: "fk_rails_f83c42cef4"
    t.index ["uuid"], name: "index_solutions_on_uuid"
  end

  create_table "submission_analyses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "submission_id", null: false
    t.integer "ops_status", limit: 2, null: false
    t.json "data"
    t.string "tooling_job_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["submission_id"], name: "index_submission_analyses_on_submission_id"
  end

  create_table "submission_files", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "submission_id", null: false
    t.string "filename", null: false
    t.binary "file_contents"
    t.text "digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uri", null: false
    t.index ["submission_id"], name: "fk_rails_d1aca45f2f"
  end

  create_table "submission_representations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "submission_id", null: false
    t.string "tooling_job_id", null: false
    t.integer "ops_status", limit: 2, null: false
    t.text "ast"
    t.string "ast_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["submission_id"], name: "index_submission_representations_on_submission_id"
  end

  create_table "submission_test_runs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "submission_id", null: false
    t.string "tooling_job_id", null: false
    t.string "status", null: false
    t.text "message"
    t.integer "ops_status", limit: 2, null: false
    t.json "raw_results", null: false
    t.integer "version", limit: 1, default: 0, null: false
    t.text "output"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["submission_id"], name: "index_submission_test_runs_on_submission_id"
  end

  create_table "submissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.string "uuid", null: false
    t.integer "tests_status", default: 0, null: false
    t.integer "representation_status", default: 0, null: false
    t.integer "analysis_status", default: 0, null: false
    t.string "submitted_via", null: false
    t.string "git_slug", null: false
    t.string "git_sha", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["solution_id"], name: "index_submissions_on_solution_id"
    t.index ["uuid"], name: "index_submissions_on_uuid", unique: true
  end

  create_table "team_invitations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "invited_by_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", null: false
    t.index ["invited_by_id"], name: "fk_rails_654806c772"
    t.index ["team_id", "email"], name: "index_team_invitations_on_team_id_and_email", unique: true
  end

  create_table "team_memberships", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "user_id"], name: "index_team_memberships_on_team_id_and_user_id", unique: true
    t.index ["team_id"], name: "fk_rails_61c29b529e"
    t.index ["user_id"], name: "fk_rails_5aba9331a7"
  end

  create_table "team_solutions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.string "uuid", null: false
    t.bigint "exercise_id", null: false
    t.string "git_sha", null: false
    t.string "git_slug", null: false
    t.boolean "needs_feedback", default: false, null: false
    t.boolean "has_unseen_feedback", default: false, null: false
    t.integer "num_iterations", default: 0, null: false
    t.datetime "downloaded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "fk_rails_ba74ecfdce"
    t.index ["team_id"], name: "fk_rails_1c8d2e5b15"
    t.index ["user_id", "team_id", "exercise_id"], name: "index_team_solutions_on_user_id_and_team_id_and_exercise_id", unique: true
  end

  create_table "teams", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "token", null: false
    t.boolean "url_join_allowed", default: true, null: false
    t.index ["slug"], name: "index_teams_on_slug", unique: true
    t.index ["token"], name: "index_teams_on_token", unique: true
  end

  create_table "testimonials", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "track_id"
    t.string "headline", null: false
    t.text "content", null: false
    t.string "byline", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "fk_rails_c5eac2171d"
  end

  create_table "topics", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "track_concepts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.string "slug", null: false
    t.string "uuid", null: false
    t.string "name", null: false
    t.string "blurb", limit: 350
    t.string "synced_to_git_sha", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["track_id"], name: "index_track_concepts_on_track_id"
    t.index ["uuid"], name: "index_track_concepts_on_uuid", unique: true
  end

  create_table "tracks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "slug", null: false
    t.string "title", null: false
    t.string "repo_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.integer "median_wait_time"
    t.string "blurb", limit: 400, null: false
    t.string "synced_to_git_sha", null: false
    t.json "tags"
    t.integer "num_exercises", limit: 3, default: 0, null: false
    t.integer "num_concepts", limit: 3, default: 0, null: false
    t.index ["slug"], name: "index_tracks_on_slug", unique: true
  end

  create_table "user_acquired_badges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "user_id", null: false
    t.bigint "badge_id", null: false
    t.boolean "revealed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["badge_id"], name: "index_user_acquired_badges_on_badge_id"
    t.index ["user_id", "badge_id"], name: "index_user_acquired_badges_on_user_id_and_badge_id", unique: true
    t.index ["user_id"], name: "index_user_acquired_badges_on_user_id"
    t.index ["uuid"], name: "index_user_acquired_badges_on_uuid", unique: true
  end

  create_table "user_activities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "user_id", null: false
    t.bigint "track_id"
    t.bigint "exercise_id"
    t.bigint "solution_id"
    t.json "params", null: false
    t.datetime "occurred_at", null: false
    t.string "uniqueness_key", null: false
    t.integer "version", null: false
    t.json "rendering_data_cache", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id"], name: "index_user_activities_on_exercise_id"
    t.index ["solution_id"], name: "index_user_activities_on_solution_id"
    t.index ["track_id"], name: "index_user_activities_on_track_id"
    t.index ["uniqueness_key"], name: "index_user_activities_on_uniqueness_key", unique: true
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "user_auth_tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_user_auth_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_user_auth_tokens_on_user_id"
  end

  create_table "user_email_logs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "mentor_heartbeat_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "remind_about_solution_sent_at"
    t.index ["user_id"], name: "index_user_email_logs_on_user_id", unique: true
  end

  create_table "user_notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "user_id", null: false
    t.bigint "track_id"
    t.bigint "exercise_id"
    t.integer "status", limit: 1, default: 0, null: false
    t.string "path", null: false
    t.string "type", null: false
    t.integer "version", null: false
    t.json "params", null: false
    t.integer "email_status", limit: 1, default: 0, null: false
    t.string "uniqueness_key", null: false
    t.json "rendering_data_cache", null: false
    t.datetime "read_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id"], name: "index_user_notifications_on_exercise_id"
    t.index ["track_id"], name: "index_user_notifications_on_track_id"
    t.index ["uniqueness_key"], name: "index_user_notifications_on_uniqueness_key", unique: true
    t.index ["user_id"], name: "index_user_notifications_on_user_id"
    t.index ["uuid"], name: "index_user_notifications_on_uuid", unique: true
  end

  create_table "user_profiles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "display_name"
    t.string "twitter"
    t.string "website"
    t.string "github"
    t.string "linkedin"
    t.string "medium"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id", unique: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_e424190865"
  end

  create_table "user_reputation_tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "type", null: false
    t.bigint "user_id", null: false
    t.bigint "exercise_id"
    t.bigint "track_id"
    t.string "uniqueness_key", null: false
    t.integer "value", null: false
    t.string "reason", null: false
    t.string "category", null: false
    t.json "params", null: false
    t.string "level"
    t.integer "version", null: false
    t.json "rendering_data_cache", null: false
    t.string "external_url"
    t.boolean "seen", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exercise_id"], name: "index_user_reputation_tokens_on_exercise_id"
    t.index ["track_id"], name: "index_user_reputation_tokens_on_track_id"
    t.index ["uniqueness_key", "user_id"], name: "index_user_reputation_tokens_on_uniqueness_key_and_user_id", unique: true
    t.index ["user_id"], name: "index_user_reputation_tokens_on_user_id"
  end

  create_table "user_track_learnt_concepts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_track_id", null: false
    t.bigint "track_concept_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["track_concept_id"], name: "index_user_track_learnt_concepts_on_track_concept_id"
    t.index ["user_track_id"], name: "index_user_track_learnt_concepts_on_user_track_id"
  end

  create_table "user_track_mentorships", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "track_id", null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "fk_rails_4a81f96f88"
    t.index ["user_id", "track_id"], name: "index_user_track_mentorships_on_user_id_and_track_id", unique: true
    t.index ["user_id"], name: "fk_rails_283ecc719a"
  end

  create_table "user_tracks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "track_id", null: false
    t.boolean "anonymous_during_mentoring", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "paused_at"
    t.string "summary_key"
    t.json "summary_data"
    t.index ["track_id", "user_id"], name: "index_user_tracks_on_track_id_and_user_id", unique: true
    t.index ["user_id"], name: "fk_rails_99e944edbc"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "handle", limit: 190, null: false
    t.string "avatar_url"
    t.text "bio"
    t.string "email", limit: 190, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token", limit: 190
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token", limit: 190
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "provider"
    t.string "uid"
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "accepted_privacy_policy_at"
    t.datetime "accepted_terms_at"
    t.boolean "dark_code_theme", default: false, null: false
    t.boolean "is_mentor", default: false, null: false
    t.boolean "default_allow_comments"
    t.datetime "deleted_at"
    t.datetime "joined_research_at"
    t.boolean "show_v3_patience_modal", default: true, null: false
    t.boolean "show_introducing_research_modal", default: true, null: false
    t.string "github_username"
    t.datetime "became_mentor_at"
    t.integer "reputation", default: 0, null: false
    t.json "roles"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["handle"], name: "index_users_on_handle", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

<<<<<<< HEAD
=======
  create_table "v2_discussion_posts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "iteration_id", null: false
    t.bigint "user_id"
    t.text "content", size: :long, null: false
    t.text "html", size: :long, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "edited", default: false, null: false
    t.text "previous_content", size: :long
    t.boolean "deleted", default: false, null: false
    t.string "type"
    t.index ["iteration_id"], name: "fk_rails_f58a02b68e"
  end

  create_table "v2_notifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "about_type"
    t.bigint "about_id"
    t.string "trigger_type"
    t.bigint "trigger_id"
    t.string "type"
    t.text "content"
    t.text "link"
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "fk_rails_b080fb4855"
  end

  create_table "v2_submission_test_runs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "submission_id", null: false
    t.string "results_status"
    t.text "message"
    t.json "tests"
    t.json "results"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ops_status", limit: 2, null: false
    t.text "ops_message"
    t.index ["submission_id"], name: "fk_rails_3812c45ada"
  end

  create_table "v2_submissions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.boolean "tested", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.json "filenames", null: false
    t.string "solution_type", null: false
    t.index ["solution_id", "id"], name: "index_v2_submissions_on_solution_id_and_id"
    t.index ["solution_type", "solution_id"], name: "index_v2_submissions_on_solution_type_and_solution_id"
    t.index ["tested", "id"], name: "index_v2_submissions_on_tested_and_id"
    t.index ["uuid"], name: "index_v2_submissions_on_uuid", unique: true
  end

  add_foreign_key "auth_tokens", "users"
  add_foreign_key "blog_comments", "blog_comments"
  add_foreign_key "blog_comments", "blog_posts"
  add_foreign_key "blog_comments", "users"
  add_foreign_key "bug_reports", "users"
  add_foreign_key "communication_preferences", "users"
  add_foreign_key "documents", "tracks"
  add_foreign_key "exercise_authorships", "exercises"
  add_foreign_key "exercise_authorships", "users"
  add_foreign_key "exercise_contributorships", "exercises"
  add_foreign_key "exercise_contributorships", "users"
  add_foreign_key "exercise_practiced_concepts", "exercises"
  add_foreign_key "exercise_practiced_concepts", "track_concepts"
  add_foreign_key "exercise_prerequisites", "exercises"
  add_foreign_key "exercise_prerequisites", "track_concepts"
  add_foreign_key "exercise_representations", "exercises"
  add_foreign_key "exercise_representations", "submissions", column: "source_submission_id"
  add_foreign_key "exercise_representations", "users", column: "feedback_author_id"
  add_foreign_key "exercise_representations", "users", column: "feedback_editor_id"
  add_foreign_key "exercise_taught_concepts", "exercises"
  add_foreign_key "exercise_taught_concepts", "track_concepts"
  add_foreign_key "exercise_topics", "exercises"
  add_foreign_key "exercise_topics", "topics"
  add_foreign_key "exercises", "tracks"
  add_foreign_key "github_pull_request_reviews", "github_pull_requests"
  add_foreign_key "ignored_solution_mentorships", "solutions"
  add_foreign_key "ignored_solution_mentorships", "users"
  add_foreign_key "infrastructure_test_runner_versions", "infrastructure_test_runners", column: "test_runner_id"
  add_foreign_key "iteration_analyses", "iterations"
  add_foreign_key "maintainers", "tracks"
  add_foreign_key "maintainers", "users"
  add_foreign_key "mentor_discussion_posts", "iterations"
  add_foreign_key "mentor_discussion_posts", "mentor_discussions", column: "discussion_id"
  add_foreign_key "mentor_discussion_posts", "users"
  add_foreign_key "mentor_discussions", "mentor_requests", column: "request_id"
  add_foreign_key "mentor_discussions", "solutions"
  add_foreign_key "mentor_discussions", "users", column: "mentor_id"
  add_foreign_key "mentor_profiles", "users"
  add_foreign_key "mentor_requests", "solutions"
  add_foreign_key "mentor_requests", "users", column: "locked_by_id"
  add_foreign_key "mentor_student_relationships", "users", column: "mentor_id"
  add_foreign_key "mentor_student_relationships", "users", column: "student_id"
  add_foreign_key "mentor_testimonials", "mentor_discussions", column: "discussion_id"
  add_foreign_key "mentor_testimonials", "users", column: "mentor_id"
  add_foreign_key "mentor_testimonials", "users", column: "student_id"
  add_foreign_key "problem_reports", "exercises"
  add_foreign_key "problem_reports", "tracks"
  add_foreign_key "problem_reports", "users"
  add_foreign_key "mentors", "tracks"
  add_foreign_key "repo_update_fetches", "repo_updates"
  add_foreign_key "research_experiment_solutions", "exercises"
  add_foreign_key "research_experiment_solutions", "research_experiments", column: "experiment_id"
  add_foreign_key "research_experiment_solutions", "users"
  add_foreign_key "research_user_experiments", "research_experiments", column: "experiment_id"
  add_foreign_key "research_user_experiments", "users"
  add_foreign_key "scratchpad_pages", "users"
  add_foreign_key "solution_locks", "solutions"
  add_foreign_key "solution_locks", "users"
  add_foreign_key "solutions", "exercises"
  add_foreign_key "solutions", "users"
  add_foreign_key "submission_analyses", "submissions"
  add_foreign_key "submission_files", "submissions"
  add_foreign_key "submission_representations", "submissions"
  add_foreign_key "submission_test_runs", "submissions"
  add_foreign_key "submissions", "solutions"
  add_foreign_key "team_invitations", "teams"
  add_foreign_key "team_invitations", "users", column: "invited_by_id"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_memberships", "users"
  add_foreign_key "team_solutions", "exercises"
  add_foreign_key "team_solutions", "teams"
  add_foreign_key "team_solutions", "users"
  add_foreign_key "testimonials", "tracks"
  add_foreign_key "track_concepts", "tracks"
  add_foreign_key "user_acquired_badges", "badges"
  add_foreign_key "user_acquired_badges", "users"
  add_foreign_key "user_activities", "exercises"
  add_foreign_key "user_activities", "solutions"
  add_foreign_key "user_activities", "tracks"
  add_foreign_key "user_activities", "users"
  add_foreign_key "user_auth_tokens", "users"
  add_foreign_key "user_email_logs", "users"
  add_foreign_key "user_notifications", "exercises"
  add_foreign_key "user_notifications", "tracks"
  add_foreign_key "user_notifications", "users"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "user_reputation_tokens", "exercises"
  add_foreign_key "user_reputation_tokens", "tracks"
  add_foreign_key "user_reputation_tokens", "users"
  add_foreign_key "user_track_learnt_concepts", "track_concepts"
  add_foreign_key "user_track_learnt_concepts", "user_tracks"
  add_foreign_key "user_track_mentorships", "tracks"
  add_foreign_key "user_track_mentorships", "users"
  add_foreign_key "user_tracks", "tracks"
  add_foreign_key "user_tracks", "users"
  add_foreign_key "v2_discussion_posts", "iterations"
  add_foreign_key "v2_notifications", "users"
end
