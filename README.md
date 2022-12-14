# Docker yml setup for php 8.1, mysql and nginx and instructions for laravel setup
```
git clone https://github.com/pompy/laravel_docker_setup
```
Create app/public folder and place  laravel project.Its mapped with port 81 to access. 
Incase you want to test a php file then create another folder public (within public folder). Laravel installation creates another public folder within root. You may modify nginx.conf according to your requirement. 
Test url: http://localhost:81/yourphpfile.php 
 

### STEPS TO START LARAVEL

#### 1) Build your docker
```
docker-compose --project-name pompy up -d --build
```

#### 2) Bash your container
```
docker  exec -it pompy_php /bin/bash
```

#### 3) cd /app cd public (just go to the source folder where you will install laravel. Create app/public folder [in your folder where you are running  docker yml file] ) Your bash path should loook something like root@3434:/app/public#       [In case you want to run  stray php file then just create another public folder within public and place your php files - Ngnix setting is done for latest laravel framework v9 and you are always free to change it]

#### 4) Get composer -- in case composer doesnt work (Optional)
```
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
```

#### 5) Install Laravel inside bash at this location root@3434:/app/public#
```
composer create-project laravel/laravel .
```

#### 6) storage  permission for laravel
```
sudo chmod -R ugo+rw storage
```

#### 7) try to run http://localhost:81/ to see default page of laravel. If page loads all is well.

#### 8) Below are mostly to do with Laravel related operations (Some knowledge of laravel migration & seeding is important)


## Change laravel database  settings in .env variable. (Settings should match with credentials in docker-compose file)
> DB_CONNECTION=mysql  
> DB_HOST=mysql  
> DB_PORT=3306  
> DB_DATABASE=mydb  
> DB_USERNAME=admin  
> DB_PASSWORD=admin  


##  You can login into bash using (to fire various commands)
> docker  exec -it pompy_php /bin/bash

##  Make model 
```
artisan make:model MyTable -fms
```

##  Now goto /database/migrations/YYYY_MM_DD_HHMMSS_create_mytable_table.php and update up function with below

  > $table->id();  
  > $table->text('name');  
  > $table->string('description');  
  > $table->string('year');  
  > $table->timestamps();  

##   Now goto /database/seeders/MyTableSeeder.php and add inside run function  
  
  > MyTable::factory()->times(50)->create();    
  > & add model at the top    
  > use App\Models\MyTable;  


##  Now @ /database/seeders/DatabaseSeeder.php  
Add  
> $this->call(  
>           [  
>                MyTableSeeder::class  
>            ]  
>        );   
  
##  Now @ /database/factories/MyTableFactory.php add  
  
> return [  
>           'name' => $this->faker->sentence(),  
>             'description' => $this->faker->name(),  
>             'year' => $this->faker->year(),  
>         ];  
  
##  Run php artisan migrate:fresh --seed
> (table will get created as you would see in the console)

##  Also google adminer and load adminer.php to access database and see if table is created. It should also show data.

<https://www.adminer.org/>


##  Create controller  
```
php artisan make:controller MyTableController  
```
  
and inside /app/Http/Controllers/MyTableController.php  
  
> use App\Models\MyTable;    
  
> public function index(){  
>         return view('mytables.index', ['mytables' => Quote::all()]);  
>     }  
  
##  Now u need to create view files  
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

##  Now in /routes/web.php  
  
```
Route::get('/', [App\Http\Controllers\MyTableController::class, 'index']);  
```
Now run http://localhost:81/ in browser to see this page   

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
```
php artisan migrate:refresh --path=/database/migrations/newtable.php
```
> 
## Another tinker
```
php artisan tinker
```
``` 
Schema::table('my_tables', function(\Illuminate\Database\Schema\Blueprint $table){ $table->integer('isadded'); })
```
## Migrate refresh and fresh
> 
> You can use migrate:refresh instead of migrate:fresh so that data isnt removed
> 

## Handy Stuff For Laravel CRUD Rest Api (api.php) and web page rendering
### Rest Api - Edit  api.php 
#### Sample url http://localhost:81/api/test/
``` 
use App\Http\Controllers\QuoteController;

Route::get('/test', function () {return "pompy is testing";});


Route::get('/quote',[QuoteController::class, 'index']);
Route::get('/quote/{id}',[QuoteController::class, 'show']);
Route::post('/quote',[QuoteController::class, 'store']);
Route::put('/quote/{id}',[QuoteController::class, 'update']);
Route::delete('/quote/{id}',[QuoteController::class, 'destroy']);
``` 

### Web Rendering (basically frontend) - Edit  web.php 
#### Sample url http://localhost:81/
``` 
Route::get('/', [App\Http\Controllers\QuoteController::class, 'all']);
``` 
### Controller Editing - Edit QuoteController.php  (Make sure you also have the model defined)
``` 
use App\Models\Quote;

	 public function all(){
		return view('quotes.index', ['quotes' => Quote::all()]); }
	
	 public function index(){
        $quote = Quote::all();
        return response()->json($quote);
    }
	
	
	 public function show($id) {
        $quote = Quote::find($id);
        if(!empty($quote))
        {
            return response()->json($quote);
        }
        else
        {
            return response()->json([
                "message" => "Record not found"
            ], 404);
        }
    }
	
	public function store(Request $request) {
        $quote = new Quote;
        $quote->quote = $request->quote;
        $quote->historian = $request->historian;
        $quote->year = $request->year;
        $quote->updated_at = $request->updated_at;
        $quote->save();
        return response()->json([
            "message" => "Record Added."
        ], 201);
    }
	
	public function update(Request $request, $id){
        if (Quote::where('id', $id)->exists()) {
            $quote = Quote::find($id);
            $quote->quote = is_null($request->quote) ? $quote->quote : $request->quote;
            $quote->historian = is_null($request->historian) ? $quote->historian : $request->historian;
            $quote->year = is_null($request->year) ? $quote->year : $request->year;
            $quote->updated_at = is_null($request->updated_at) ? $quote->updated_at : $request->updated_at;
            $quote->save();
            return response()->json([
                "message" => "Record Updated."
            ], 204);
        }else{
            return response()->json([
                "message" => "Record Not Found."
            ], 404);
        }
    }
	
	
	public function destroy($id){
        if(Quote::where('id', $id)->exists()) {
            $quote = Quote::find($id);
            $quote->delete();

            return response()->json([
              "message" => "records deleted."
            ], 202);
        } else {
            return response()->json([
              "message" => "Record not found."
            ], 404);
        }
    }
``` 

## Other handy commands
```
> docker ps  
> docker-compose down  
> docker-compose down --remove-orphans 
```

