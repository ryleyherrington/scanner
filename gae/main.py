#!/usr/bin/env python

import webapp2
import json
import time
import datetime 

from google.appengine.ext import db

class Item(db.Model):
	name		= db.StringProperty()
	borrower	= db.StringProperty()
	attributes	= db.StringProperty() 
	barcode 	= db.StringProperty()
	features 	= db.StringProperty()
	accessories	= db.StringProperty()
	OS 			= db.StringProperty()
	pages 		= db.StringProperty()
	other 		= db.StringProperty(multiline=True)
	history 	= db.StringProperty(multiline=True)	
	available	= db.IntegerProperty()
	date 		= db.DateProperty(auto_now_add=True)

class RecentBarcode(db.Model):
	barcode = db.StringProperty()
	date = db.DateProperty(auto_now_add=True)

class InsertBarcode(webapp2.RequestHandler):
	def get(self):
		self.response.out.write("HEY")
	
#		self.response.out.write("<html><body>")
#        self.response.out.write("""
#            <form action="/insertBarcode" method="post">
#                <div>Barcode:</br><input type=text name="barcode"></textarea></div>
#                <div><input type="submit" value="Enter Item"></div>
#            </form>
#        </body>
#        </html>""")
#        self.response.out.write("</body></html>")

	def post(self):
		bar = Barcode()
		bar.barcode = self.request.get('barcode')
		bar.put()	
		self.redirect('/android')

class InsertItem(webapp2.RequestHandler):
	
	def get(self):	
		self.response.out.write("<html><body>")
		self.response.out.write("""
            <form action="/insert" method="post">
                <div>Item Name:</br><input type=text name="name"></textarea></div>
                <div>Borrower:</br><input type=text name="borrower"></textarea></div>
                <div>Attributes:</br><input type=text name="attributes"></textarea></div>
                <div>Barcode:</br><input type=text name="barcode"></textarea></div>
                <div>Features:</br><input type=text name="features"></textarea></div>
                <div>Accessories:</br><input type=text name="accessories"></textarea></div>
                <div>OS:</br><input type=text name="OS"></textarea></div>
                <div>Pages:</br><input type=text name="pages"></textarea></div>
                <div>Other:</br><textarea name="other" rows="3" cols="60"></textarea></div>
                <div><input type="submit" value="Enter Item"></div>
            </form>
        </body>
        </html>""")
		self.response.out.write("</body></html>")
	
	def post(self):
		item = Item()
		item.name			= self.request.get('name')
		item.attributes		= self.request.get('attributes')
		item.barcode		= self.request.get('barcode')
		item.features		= self.request.get('features')
		item.accessories	= self.request.get('accessories')
		item.OS				= self.request.get('OS')
		item.other			= self.request.get('other')
		item.pages			= self.request.get('pages')
		item.borrower		= self.request.get('borrower')
		item.available 		= 0
		item.history 		= "Borrowed by " + item.borrower
		item.put()
		self.redirect('/')

class Android(webapp2.RequestHandler):
	def get(self):
	
		barcode = db.GqlQuery("SELECT * FROM Barcode LIMIT 1", barcode)
		for  
        self.response.out.write("<html><body>")
        self.response.out.write("""
            <form action="/insert" method="post">
                <div>Item Name:</br><input type=text name="name"></textarea></div>
                <div>Borrower:</br><input type=text name="borrower"></textarea></div>
                <div>Attributes:</br><input type=text name="attributes"></textarea></div>
                <div>Barcode:</br><input type=text name="barcode">"""+barcode+"""</textarea></div>
                <div>Features:</br><input type=text name="features"></textarea></div>
                <div>Accessories:</br><input type=text name="accessories"></textarea></div>
                <div>OS:</br><input type=text name="OS"></textarea></div>
                <div>Pages:</br><input type=text name="pages"></textarea></div>
                <div>Other:</br><textarea name="other" rows="3" cols="60"></textarea></div>
                <div><input type="submit" value="Enter Item"></div>
            </form>
        </body>
        </html>""")
        self.response.out.write("</body></html>")
   
	def post(self):
		barcode = RecentBarcode()
		barcode.barcode= self.request.get('barcode')
		barcode.put()
		self.redirect('/android')
			

class CheckoutItem(webapp2.RequestHandler):

	def get(self):	
		self.response.out.write("<html><body>")
		self.response.out.write("""
            <form action="/checkout" method="post">
                <div>Item Name:</br><input type=text name="name"></textarea></div>
                <div>Borrower:</br><input type=text name="borrower"></textarea></div>
                <div>Barcode:</br><input type=text name="barcode"></textarea></div>
                <div>Other:</br><textarea name="other" rows="3" cols="60"></textarea></div>
                <div><input type="submit" value="Enter Item"></div>
            </form>
        </body>
        </html>""")
		self.response.out.write("</body></html>")

	def post(self):
		borrower  = self.request.get('borrower')
		barcode	  = self.request.get('barcode')
		other	  = self.request.get('other')

		item = db.GqlQuery("SELECT * From Item WHERE barcode = :1 LIMIT 1 ", barcode)
		for i in item:
			i.other = i.other + "\n" + other
			i.history = i.history + "\n Borrowed by " + borrower+'. ';
			i.available = 0
			i.put()

class CheckinItem(webapp2.RequestHandler):

	def get(self):	
		self.response.out.write("<html><body>")
		self.response.out.write("""
            <form action="/checkin" method="post">
                <div>Borrower:</br><input type=text name="borrower"></textarea></div>
                <div>Barcode:</br><input type=text name="barcode"></textarea></div>
                <div>Other:</br><textarea name="other" rows="3" cols="60"></textarea></div>
                <div><input type="submit" value="Enter Item"></div>
            </form>
        </body>
        </html>""")
		self.response.out.write("</body></html>")
	

	def post(self):
		borrower  = self.request.get('borrower')
		barcode	  = self.request.get('barcode')
		other	  = self.request.get('other')

		self.response.headers['Content-Type'] = 'application/json'   

		items = db.GqlQuery("SELECT * FROM Item WHERE barcode = :1 LIMIT 1", barcode)
		output = list()
		for i in items:
			if (i.borrower == borrower):
				output.append(to_dict(i))
				i.borrower = 'No one is borrowing this.';
				i.other = i.other + ", " + other
				i.history = i.history + "\n Returned by " + str(borrower)+ '. ';
				i.available = 1
				i.put()
		self.response.out.write("The wrong person checked it in");
		outputDict = {"items":output}
		self.response.out.write(json.dumps(outputDict))


SIMPLE_TYPES = (int, long, float, bool, dict, basestring, list)
def to_dict(model):
    dictionary = {}

    for key, prop in model.properties().iteritems():
        value = getattr(model, key)
        
        if value is None or isinstance(value, SIMPLE_TYPES):
            dictionary[key] = value
        elif isinstance(value, datetime.date):
            dictionary[key] = str(value)
        elif isinstance(value, db.Model):
            dictionary[key] = to_dict(value)
        else:
            raise ValueError('Failed: ' + repr(prop))
    
    return dictionary

class SingleItem(webapp2.RequestHandler):

	def get(self):
		self.response.out.write("<html><body>")
		self.response.out.write("""
            <form action="/item" method="post">
                <div>Name:</br><input type=text name="name"></textarea></div>
                <div>Borrower:</br><input type=text name="borrower"></textarea></div>
                <div><input type="submit" value="Enter Item"></div>
            </form>
        </body>
        </html>""")
		self.response.out.write("</body></html>")

	def post(self):
		name = self.request.get("name")
		borrower = self.request.get("borrower")
		
		items = db.GqlQuery("SELECT * FROM Item WHERE name = :1 AND borrower:2LIMIT 1", name, borrower)

		output = list()
		for i in items:
			output.append(to_dict(i))

		outputDict = {"items":output}
		self.response.out.write(json.dumps(outputDict))

class MainHandler(webapp2.RequestHandler):

	def get(self):
		items = db.GqlQuery("SELECT * FROM Item")
		self.response.headers['Content-Type'] = 'application/json'   

		output = list()
		for item in items:
			output.append(to_dict(item))

		outputDict = {"items":output}
		self.response.out.write(json.dumps(outputDict))

app = webapp2.WSGIApplication([
	('/', MainHandler),
	('/insert', InsertItem),
	('/item', SingleItem),
	('/checkout', CheckoutItem),
	('/fix', Fix),
	('/android', Android),
	('/barcode', InsertBarcode),
	('/checkin', CheckinItem)
], debug=True)
