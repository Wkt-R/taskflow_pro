# Taskflow Pro

## Tech Stack

**Backend:** Ruby on Rails 7.2  
**Frontend:** Hotwire (Turbo + Stimulus), TailwindCSS, ESBuild  
**Database:** PostgreSQL  
**Background Jobs:** Sidekiq + Redis  
**Process Management:** Foreman (Procfile.dev)  
**Authentication:** Devise  
**Deployment:** Kamal (optional)  

---

## Features

- Full CRUD task management built on Rails conventions  
- Authentication and session management with Devise  
- Real-time UI updates via Turbo and Stimulus  
- Responsive UI styled with TailwindCSS  
- Background job processing with Sidekiq  
- Foreman-based setup for smooth local development  

---

## Requirements

- Ruby **3.3+**  
- Node.js **18+**  
- Yarn **1.22+**  
- PostgreSQL **13+**  
- Redis **7+**

---

## Setup & Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/Wkt-R/taskflow_pro.git
   cd taskflow_pro
   
2. **Install Ruby dependencies**
   
    ```bash
    bundle install

3. **Instal JavaScript dependencies**

    ```bash
    yarn install

4. **Setup database**

    ```bash
    rails db:create db:migrate db:seed

5. **Run development enviroment**

    ```bash
    foreman start -f Procfile.dev

### This will launch:
- **Rails server**(bin/rails server)
- **JS bundler**(yarn build:watch)
- **TailwindCSS**(yarn build:css)
- **Sidekiq** (bundle exec sidekiq -C config/sidekiq.yml)

## Project structure

    app/
     ├─ controllers/    # Rails controllers
     ├─ models/         # ActiveRecord models
     ├─ views/          # ERB templates
     ├─ javascript/     # Stimulus controllers & entrypoints
     └─ assets/         # TailwindCSS, builds, and images
    config/
     ├─ environments/   # Environment configs
     ├─ routes.rb       # Route definitions
     └─ sidekiq.yml     # Sidekiq configuration
    Procfile.dev        # Foreman process definitions
    Gemfile             # Ruby gem dependencies
    package.json        # Node.js dependencies

## Frontend
- Bundled using **Esbuild**(jsbundling-rails)
- TailwindCSS via **cssbundling-rails**
- stimulus controllers located in **app/javascript/controllers/**
- Configuration in **tailwind.config.js**

## Background jobs
- Uses **sidekiq** for background processing
- Requires **Redis** running locally:
    ```bash
    redis-server
