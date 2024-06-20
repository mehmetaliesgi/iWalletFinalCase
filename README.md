# iWalletFinalCase

Merhaba,
Öncelikle ben "https://jsonplaceholder.typicode.com/users" API'a POST isteği atılmadığı için json-server ile projeme başladım. Testlerimi bu şekilde yürüttüm. Öncelikle json-server kurulumu bu anlatayım.

- `npm install -g json-server` komutu ile kurulumu yapıyoruz
- db.json adında bir dosya oluşturuyoruz.
- Dummy data ekliyoruz.
- `json-server --watch db.json --port 3001` komutu ile 3001 portunda serverı ayağa kaldırıyoruz.
- Artık Rails uygulamamızda localhost:3001 adresine istek atabiliriz.

HTTP isteklerini yapmak için faraday gem'ini kullandım.

Search ve popup modülleri için Turbo Stimulus kullandım.

Rails projemizi ayağa kaldırmak için;

- bin/dev

Projemde sidekiq background job'ını kullandım. API'da yapılan bir post, update işleminde bu job çalışıp veritabanımızda yeni bir veri ekliyor veya bir veriyi güncelleme işlemini yapıyor. Bu şekilde hem API tarafındaki verilerimiz hemde database tarafındaki verilerimiz güncel ve eşitlenmiş oluyor.

## Anasayfa

![alt text](image-1.png)
![alt text](image-2.png)

## User Create

![alt text](image-10.png)
![alt text](image-11.png)

## User Show

![alt text](image-3.png)
![alt text](image-4.png)
![alt text](image-5.png)

## User Edit

![alt text](image-6.png)
![alt text](image-7.png)

## Search

![alt text](image-8.png)
![alt text](image-9.png)

## Popup

![alt text](image-16.png)
![alt text](image-17.png)
