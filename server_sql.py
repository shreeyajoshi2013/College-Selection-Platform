from datetime import datetime
from django.db import connection
from django.contrib.auth.hashers import check_password, make_password
import json
from passlib.hash import sha512_crypt as sha512

cursor = connection.cursor()

def to_json(cursor):
    row_headers=[x[0] for x in cursor.description] 
    rv = cursor.fetchall()
    json_data=[]
    for result in rv:
        json_data.append(dict(zip(row_headers, result)))
    return json.dumps(json_data, indent=4, sort_keys=True, default=str)

def get_user(username):
    try:
        cursor.execute("SELECT id, username, password, role FROM user WHERE username = %s", [username])
    except Exception as e:
        return False
    return to_json(cursor)
    

def get_user_details(user_id):
    try:
        cursor.execute("SELECT U.id, username, role, email, firstName, lastName, createdOn, updatedOn, country, city, state, zipCode FROM user AS U INNER JOIN userprofile AS UP ON U.id = UP.id WHERE U.id = %s", [user_id])
    except Exception as e:
        return False

    return to_json(cursor)

def get_all_users():
    try:
        cursor.execute("SELECT U.id, username, role, email, firstName, lastName, createdOn, updatedOn, country, city, state, zipCode FROM user AS U INNER JOIN userprofile AS UP ON U.id = UP.id")
    except Exception as e:
        return False

    return to_json(cursor)
    

def add_user(data):
    cursor.execute("SELECT MAX(id) from user")
    id = cursor.fetchone()[0] + 1
    first_name = data.get('first_name', None)
    last_name = data.get('last_name', None)
    password = sha512.encrypt(data["password"], rounds=5000, implicit_rounds=True)
    email = data.get('email', None)
    username = data.get('username', None)
    country = data.get('country', None)
    state = data.get('state', None)
    city = data.get('city', None)
    zip_code = data.get('zip_code', None)
    role = data.get('role', None)
    # try:
    cursor.execute("INSERT INTO user(id, username, password, role) VALUES(%s, %s ,%s, %s)", [id, username, password, role])
    cursor.execute("INSERT INTO userprofile(id, email, firstName, lastName, createdOn, updatedOn, country, city, state, zipCode) VALUES(%s, %s ,%s, %s, %s, %s, %s ,%s, %s, %s)", [id, email, first_name, last_name, str(datetime.now()), str(datetime.now()), country, city, state, zip_code])
    # except Exception as e:
    #     return False

    return True

def update_user(data, user_id):
    first_name = data.get('first_name', None)
    last_name = data.get('last_name', None)
    email = data.get('email', None)
    username = data.get('username', None)
    country = data.get('country', None)
    state = data.get('state', None)
    city = data.get('city', None)
    zip_code = data.get('zip_code', None)
    role = data.get('role', None)
    # try:
    cursor.execute("UPDATE user SET username=%s,role=%s WHERE id = %s", [username, role, user_id])
    cursor.execute("UPDATE userprofile SET email=%s, firstName=%s, lastName=%s, createdOn=%s, updatedOn=%s, country=%s, city=%s, state=%s, zipCode=%s WHERE id = %s", [email, first_name, last_name, str(datetime.now()), str(datetime.now()), country, city, state, zip_code, user_id])
    # except Exception as e:
    #     return False

    return get_user_details(user_id)

def delete_user(user_id):
    try:
        cursor.execute("DELETE FROM userprofile WHERE id = %s", [user_id])
        cursor.execute("DELETE FROM user WHERE id = %s", [user_id])
    except Exception as e:
        return False

    rows = cursor.fetchall()

    return True 

def get_institution(institution_id):
    try:
        cursor.execute("SELECT institutionID, institutionName, city, state, zipCode FROM institution WHERE institutionId = %s", [institution_id])
    except Exception as e:
        return False

    rows = cursor.fetchall()
    return to_json(cursor)


def add_institution(data):
    cursor.execute("SELECT MAX(id) FROM institution") + 1
    id = cursor.fetchone()[0] + 1
    name = data.get('name', None)
    city = data.get('city', None)
    state = data.get('state', None)
    zip_code = data.get('zip_code', None)
    try:
        cursor.execute("INSERT INTO institution(institutionID, institutionName, city, state, zipCode) VALUES(%s, %s, %s, %s)", [id, name, city, state, zip_code])
    except Exception as e:
        return False

    rows = cursor.fetchall()

    return True

def update_institution(data, institution_id):
    institution_name = data.get('first_name', None)
    city = data.get('city', None)
    state = data.get('state', None)
    zip_code = data.get('zip_code', None)
    try:
        cursor.execute("INSERT INTO institution(institutionName, city, state, zipCode) VALUES(%s, %s, %s) WHERE institutionID = %s", [institution_name, city, state, zip_code])
    except Exception as e:
        return False

    return True

def delete_institution(institution_id):
    try:
        cursor.execute("DELETE FROM institution WHERE institutionId = %s", [institution_id])
    except Exception as e:
        return False

    rows = cursor.fetchall()
    print(rows)

    return True

def get_all_institutions():
    try:
        cursor.execute("SELECT DISTINCT iid.institutionID, iid.institutionName, iid.city, iid.state, iid.zipCode, ii.ranking, ii.rating, ii.numreviews FROM institution AS iid INNER JOIN institutioninformation AS ii ON ii.institutionID = iid.institutionID;")
    except Exception as e:
        return False

    return to_json(cursor)

# LOWER TO HIGHER
def sort_by_ranking():
    try:
        cursor.execute("SELECT DISTINCT iid.institutionID, iid.institutionName, iid.city, iid.state, iid.zipCode, ii.ranking, ii.rating, ii.numreviews FROM institution AS iid INNER JOIN institutioninformation AS ii ON ii.institutionID = iid.institutionID ORDER BY ii.ranking;")
    except Exception as e:
        return False


    return to_json(cursor)

# HIGHER TO LOWER
def sort_by_rating():
    try:
        cursor.execute("SELECT DISTINCT iid.institutionID, iid.institutionName, iid.city, iid.state, iid.zipCode, ii.ranking, ii.rating, ii.numreviews FROM institution AS iid INNER JOIN institutioninformation AS ii ON ii.institutionID = iid.institutionID ORDER BY ii.rating DESC;")
    except Exception as e:
        return False

    return to_json(cursor)

# HIGHER TO LOWER
def sort_by_reviews():
    try:
        cursor.execute("SELECT DISTINCT iid.institutionID, iid.institutionName, iid.city, iid.state, iid.zipCode, ii.ranking, ii.rating, ii.numreviews FROM institution AS iid INNER JOIN institutioninformation AS ii ON ii.institutionID = iid.institutionID ORDER BY ii.numReviews DESC;")
    except Exception as e:
        return False

    return to_json(cursor)

def get_all_institutions():
    try:
        cursor.execute("SELECT DISTINCT iid.institutionID, iid.institutionName, iid.city, iid.state, iid.zipCode, ii.ranking, ii.rating, ii.numreviews FROM institution AS iid INNER JOIN institutioninformation AS ii ON ii.institutionID = iid.institutionID")
    except Exception as e:
        return False

    return to_json(cursor)

def get_distinct_degrees(institution_id):
    try:
        cursor.execute("SELECT DISTINCT DD.degreeTypeDesc, DD.degreeTypeLevel FROM institutiondegree AS ID INNER JOIN degreedetails AS DD on DD.degreeTypeLevel = ID.degreeTypeLevel WHERE ID.institutionID = %s", [institution_id])
    except Exception as e:
        return False

    return to_json(cursor)

def get_distinct_programmes(institution_id, degree_type_level):
    try:
        cursor.execute("SELECT programmeDesc FROM programmedetails AS PD INNER JOIN institutiondegree AS ID ON ID.programmeCode = PD.programmeCode INNER JOIN degreedetails AS DD ON DD.degreeTypeLevel = ID.degreeTypeLevel WHERE ID.institutionID = %s AND DD.degreeTypeLevel = %s ORDER BY PD.programmeDesc", [institution_id, degree_type_level])
    except Exception as e:
        return False

    return to_json(cursor)

    return True

def get_institute_fees_and_expenses(institution_id):
    try:
        cursor.execute("SELECT institutionID, totalFee, tuitionFeeInState, tuitionFeeOutState, bookSupplies, housing, miscellaneous FROM expenses WHERE institutionId = %s", [institution_id])
    except Exception as e:
        return False

    return to_json(cursor)


def get_institute_reviews(institution_id):
    try:
        cursor.execute("SELECT rating, ranking, numReviews FROM institutioninformation WHERE institutionId = %s", [institution_id])
    except Exception as e:
        return False

    return to_json(cursor)
    
def get_institute_details(institution_id):
    try:
        cursor.execute("SELECT institutionID, url, npcUrl, mainCampus, numBranch, governanceStructure, affiliation, admissionRate, totalAdmissions, pctPartTimeAdmissions, completionRate, avgFacultySalary, onCampusHousing, employeeSatisfaction, transportFacility FROM institutioninformation WHERE institutionId = %s", [institution_id])
    except Exception as e:
        return False

    return to_json(cursor)

def get_institute_data(institution_id):
    try:
        cursor.execute("SELECT institutionID, institutionName, city, state, zipCode FROM institution WHERE institutionId = %s", [institution_id])
    except Exception as e:
        return False

    return to_json(cursor)

def get_accredation_code(institution_id):
    try:
        cursor.execute("SELECT accredCode FROM accredatedby WHERE institutionId = %s", [institution_id])
    except Exception as e:
        return False

    return to_json(cursor)

def get_accredation_agency(accred_code):
    try:
        cursor.execute("SELECT accredAgency FROM accredatingagency WHERE accredCode = %s", [accred_code])
    except Exception as e:
        return False

    return to_json(cursor)

def get_all_countries():
    try:
        cursor.execute("SELECT id, name from country")
    except Exception as e:
        return False

    return to_json(cursor)