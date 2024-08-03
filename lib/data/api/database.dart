
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookbook_ia/data/models/requests/account_request.dart';
import 'package:cookbook_ia/data/models/requests/login_request.dart';
import 'package:cookbook_ia/data/models/requests/recipe_request.dart';
import 'package:cookbook_ia/data/models/requests/reset_request.dart';
import 'package:cookbook_ia/data/models/requests/signup_request.dart';
import 'package:cookbook_ia/data/models/responses/account_response.dart';
import 'package:cookbook_ia/data/models/responses/login_response.dart';
import 'package:cookbook_ia/data/models/responses/message_response.dart';
import 'package:cookbook_ia/data/models/responses/recipe_response.dart';
import 'package:cookbook_ia/domain/entities/recipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseApiProvider = Provider<Database>((ref) => Database());

class Database {

    Future<MessageResponse> setSignup(SignupRequest request) async {

      try {
        
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: request.username,
          password: request.password
        );

        final user = credential.user;    

        if(user != null) {
          await user.updateDisplayName(request.fullname);
          await user.verifyBeforeUpdateEmail(request.username);
          await user.sendEmailVerification();
          return new MessageResponse(message: 'account_create');
        }    else {
          throw const MessageResponse(message: 'app_error'); 
        } 

      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          throw const MessageResponse(message: 'email_exist'); 
        } else if (e.code == 'invalid-email') {
          throw const MessageResponse(message: 'email_invalid'); 
        }else if (e.code == 'weak-password') {
          throw const MessageResponse(message: 'weak_password'); 
        } else {
          throw const MessageResponse(message: 'app_error'); 
        }
      }  
      
    }


    Future<MessageResponse> setReset(ResetRequest request) async {

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: request.username,
        );
        return new MessageResponse(message: 'reset_sent');

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          throw const MessageResponse(message: 'user_not_found'); 
        } else if (e.code == 'invalid-email') {
          throw const MessageResponse(message: 'email_invalid'); 
        } else {
          throw const MessageResponse(message: 'app_error'); 
        }
      }  
      
    }

    Future<LoginResponse> setSignin(LoginRequest request) async {

      try {
        
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: request.username,
          password: request.password
        );

        final user = credential.user;    

        if(user != null) {
          if(user.emailVerified) { 
            return new LoginResponse(uuid: user.uid, fullname: user.displayName.toString(), username: user.email.toString(), activated: user.emailVerified);
          }
          else {
            await user.sendEmailVerification();
            throw const MessageResponse(message: 'email_verified'); 
          }
        } else {
          throw const MessageResponse(message: 'app_error'); 
        } 

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-disabled') {
          throw const MessageResponse(message: 'user_disabled'); 
        } else if (e.code == 'invalid-email') {
          throw const MessageResponse(message: 'email_invalid'); 
        }else if (e.code == 'user-not-found') {
          throw const MessageResponse(message: 'user_not_found'); 
        } else if (e.code == 'wrong-password') {
          throw const MessageResponse(message: 'wrong_password'); 
        }else if (e.code == 'invalid-credential') {
          throw const MessageResponse(message: 'invalid_credential'); 
        } else {
          throw const MessageResponse(message: 'app_error'); 
        }
      }  
      
    }

    Future<MessageResponse> setSignOut() async {
      await FirebaseAuth.instance.signOut();
      return new MessageResponse(message: 'user_signout');
    }

    Future<MessageResponse> setUpdateAccount(AccountRequest request) async {

      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(request.fullname);
      }
      
      final data = <String, String>{
        "allergies": request.allergies,
        "preferences": request.preferences
      };

      var db = FirebaseFirestore.instance;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uuid = (prefs.getString("id") ?? "");
      
      db.collection("users")
        .doc(uuid)
        .set(data)
        .onError((e, _) => print("Error writing document: $e"));

      return new MessageResponse(message: 'txt_save');

    }

    Future<AccountResponse> getUserAccount() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uuid = (prefs.getString("id") ?? "");
      var db = FirebaseFirestore.instance;
      DocumentSnapshot snapshot = await db.collection("users").doc(uuid).get();
      if(snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return new AccountResponse(allergies: data["allergies"] as String, preferences: data["preferences"] as String);
      } else {
        return new AccountResponse(allergies: "", preferences: "");
      }
    }

    Future<MessageResponse> setRecipe(RecipeRequest request) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uuid = (prefs.getString("id") ?? "");
      var db = FirebaseFirestore.instance;

      final data = <String, dynamic>{
        "name": request.name,
        "ingredients": request.ingredients,
        "instructions": request.instructions,
      };
      
      db.collection("recipes")
        .doc(uuid).collection("bookmarks")
        .doc(request.name)
        .set(data)
        .onError((e, _) => print("Error writing document: $e"));

      return new MessageResponse(message: 'txt_save');
      
    }

    Future<List<RecipeResponse>> getRecipes() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uuid = (prefs.getString("id") ?? "");
      var db = FirebaseFirestore.instance;
      List<RecipeResponse> recettes = [];

      var collection = db.collection('recipes').doc(uuid).collection('bookmarks');
      QuerySnapshot querySnapshot = await collection.get();
      
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data["id"] = doc.id;
        recettes.add(RecipeResponse.fromJson(data));
      }

      return recettes;

    }

    Future<MessageResponse> deleteRecipe(Recipe request) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uuid = (prefs.getString("id") ?? "");
      var db = FirebaseFirestore.instance;

      db.collection('recipes').doc(uuid)  
      .collection('bookmarks').doc(request.id)
      .delete();

      return new MessageResponse(message: 'txt_save');

    }


}