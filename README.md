# Docker yml setup for php, mysql and nginx and instructions for laravel setup
### Just place your php files or laravel in app/public folder and get it running
#### Use docker-compose build and docker-compose up to get it going
#### Its mapped with port 81 to access. You can change that from configurations
#### http://localhost:81/yourphpfile.php is a test url
#### dont forget to create app/public  folder. In case you want to setup laravel do keep public folder blank
 

### STEPS TO START LARAVEL

#### 1) docker-compose --project-name pompy up -d --build

#### 2) docker  exec -it pompy_php /bin/bash (get inside container)

#### 3) cd /app cd public (just go to the source folder where you will install laravel. Create app/public folder [in your folder where you are running  docker yml file] )

#### 4) curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

> (get composer -- in case composer doesnt work)

#### 5) composer create-project laravel/laravel . 
> (Laravel will be installed)

#### 6) storage  permission for laravel

> sudo chmod -R ugo+rw storage

#### 7) try to run http://localhost:81/public/  

> You will see the page

#### 8) Other Handy commands and stuffs


Change laravel database set settings in .env similar to below unless you change them.
> DB_CONNECTION=mysql  
> DB_HOST=mysql  
> DB_PORT=3306  
> DB_DATABASE=mydb  
> DB_USERNAME=admin  
> DB_PASSWORD=admin  


* You can login into bash using (to fire various commands)
> docker  exec -it pompy_php /bin/bash

* php artisan make:model MyTable -fms

* Now goto /database/migrations/YYYY_MM_DD_HHMMSS_create_mytable_table.php and update up function with below

  > $table->id();  
  > $table->text('name');  
  > $table->string('description');  
  > $table->string('year');  
  > $table->timestamps();  

*  Now goto /database/seeders/MyTableSeeder.php and add inside run function  
  
  > MyTable::factory()->times(50)->create();    
  > & add model at the top    
  > use App\Models\MyTable;  


* Now @ /database/seeders/DatabaseSeeder.php  
Add  
> $this->call(  
>           [  
>                MyTableSeeder::class  
>            ]  
>        );   
  
* Now @ /database/factories/MyTableFactory.php add  
  
> return [  
>           'name' => $this->faker->sentence(),  
>             'description' => $this->faker->name(),  
>             'year' => $this->faker->year(),  
>         ];  
  
* Run php artisan migrate:fresh --seed
> (table will get created as you would see in the console)

* Also google adminer and load adminer.php to access database and see if table is created. It should also show data.

* Also u can create controller  
> php artisan make:controller MyTableController  
  
and inside /app/Http/Controllers/MyTableController.php  
  
> use App\Models\MyTable;    
  
> public function index(){  
>         return view('mytables.index', ['mytables' => Quote::all()]);  
>     }  
  
* Now u need to create view files  
> mkdir resources/views/mytables  
> touch resources/views/mytables/index.blade.php  

and edit  
resources/views/mytables/index.blade.php  


>   \<table\>  
>   @foreach ($mytables as $mytable)  
>             \<tr\>  
>                 \<td\>{{ $loop->index + 1 }}\</td\>  
>                 \<td\>{{ $mytable->name }}\</td\>  
>                 \<td\>{{ $mytable->description }}\</td\>  
>                 \<td\>{{ $mytable->year }}\</td\>  
>             \</tr\>  
>         @endforeach  
>	  	
> \</table\>  

* Now in /routes/web.php  
add  

> Route::get('/', [App\Http\Controllers\MyTableController::class, 'index']);  


# Also to add columns
## To add column
> 
> php artisan make:migration add_isdeleted_to_my_tables_table --table=my_tables
> 
> 2022_08_12_120536_add_isdeleted_to_my_tables_table file is created inside /database/migrations
> 
> inside up()
> 
> $table->integer('isdeleted');
> 
> inside down()
> 
> $table->dropColumn('isdeleted');
> 
> Then fire 
> 
> php artisan migrate
> 
> In case anything goes wrong
> 
> php artisan migrate:rollback
> 
> Also you can add after a particular column 
> 
> eg: $table->integer('isdeleted')->after('id');
> 
> 
## Add column
> 
> php artisan make:migration add_isactive_to_my_tables
> 
> for up() -- $table->integer('isactive')->nullable()->after('isdeleted');
> 
> for down() -- $table->dropColumn('isactive');
> 
> For foreign keys
> 
> for up() -- 
> 
> $table->bigInteger('address_id')->unsigned()->nullable()->after('tel_number');
> 
> $table->foreign('address_id')->references('id')->on('addresses')->onDelete('SET NULL');
> 
> 
> for down() --
> 
> $table->dropForeign(['address_id']);
> 
> $table->dropColumn('address_id');
> 
> 
## Rought way to add a new table
> php artisan migrate:refresh --path=/database/migrations/newtable.php
> 
## Another way
> php artisan tinker
> Schema::table('my_tables', function(\Illuminate\Database\Schema\Blueprint $table){ $table->integer('isadded'); })
> 
> You can use refresh instead of fresh so that data isnt removed
> 
 
## Other handy commands
> docker ps  
> docker-compose down  
> docker-compose down --remove-orphans  

