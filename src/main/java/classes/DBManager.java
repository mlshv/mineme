package classes;

import com.mongodb.*;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.net.UnknownHostException;
import java.util.ArrayList;

/**
 * Created by logzee on 04.03.16.
 */
public class DBManager {
    private MongoCollection<Document> collection;
    private MongoDatabase db;

    public DBManager() throws UnknownHostException {
        MongoClient mongoClient = new MongoClient(new MongoClientURI(System.getenv("MONGODB_URL")));
        db = mongoClient.getDatabase("mineme");
    }

    public String findOne() {
        FindIterable<Document> myDoc = collection.find();
        return myDoc.iterator().next().toJson();
    }

    public void setCollection(String collection) {
        this.collection = db.getCollection(collection);
    }

    public void insertOne(Document document) {

    }
    public Object[] getStructTitles() {
        if (this.collection != null) {
            final ArrayList<String> result = new ArrayList<String>();
            FindIterable<Document> myDoc = collection.find();
            myDoc.forEach(new Block<Document>() {
                @Override
                public void apply(final Document document) {
                    System.out.println(">>>>>>>>>>>>>DBManager.java>>>>>>>>>>>>>>>");
                    ArrayList<Document> struct = (ArrayList<Document>) document.get("struct");
                    System.out.println(struct.get(0).toJson());
                    System.out.println(document.get("struct").getClass().getSimpleName());
                    for (Document key : struct) {
                        result.add(key.toJson());
                    }
                }
            });
            return result.toArray();
        }
        return new String[0];
    }
}
