
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from .server_sql import *
import json

@api_view(["POST"])
@permission_classes([AllowAny])
def login_method(request):
    post_data = request.data
    if post_data:
        username = post_data['username']
        password = post_data['password']
        user = get_user(username)
        user_obj = json.loads(user)
        if user_obj:
            user_obj = user_obj[0]
            return Response({'ok': True, 'user': user_obj})
            # if crypt.crypt(password, user_obj['password']) == user_obj['password']:
            #     return Response({'ok': True, 'user': user_obj})
            # else:
            #     return Response({'ok': False, 'error': 'Invalid credentials'})
        else:
            return Response({'ok': False, 'error': 'Invalid credentials'})
    else:
        return Response({'ok': False, 'error': 'Some error occured'})
    

@api_view(["GET"])
@permission_classes([AllowAny])
def logout_method(request):
    return Response({'ok': True})

@api_view(['GET'])
@permission_classes([AllowAny])
def is_authenticated(request, user_id):

    if user_id:
        curr_user = get_user_details(user_id)
        curr_user = json.loads(curr_user)
        if curr_user:
            curr_user_obj = curr_user[0]
            return Response({'ok': True, 'user': curr_user_obj,'is_logged_in': True})
    else:
        return Response({'ok': False, 'is_logged_in': False})


# GET ALL COUNTRIES

@api_view(["GET"])
@permission_classes([AllowAny])
def get_all_countries_method(request):

    countries = get_all_countries()
    if countries:
        countries = json.loads(countries)
        return Response({'ok': True, 'countries': countries })
    else:
        return Response({'ok': False})
        
# USER METHODS

@api_view(["POST"])
@permission_classes([AllowAny])
def register_method(request):
    post_data = request.data
    if post_data:
        if add_user(post_data):
            return Response({'ok': True})
        else:
            return Response({'ok': False, 'error': 'Registration Failed'})
    else:
        return Response({'ok': False, 'error': 'Some Error occured'})


@api_view(["POST"])
@permission_classes([AllowAny])
def edit_user_method(request):
    
    post_data = request.data
    if post_data:
        user = update_user(post_data, post_data['id'])
        user = json.loads(user)
        if user:
            user_obj = user[0]
            return Response({'ok': True, 'user': user_obj})
        else:
            return Response({'ok': False, 'error': 'Some error occured'})

@api_view(["GET"])
@permission_classes([AllowAny])
def get_user_details_method(request, user_id):
    
    user_details = get_user_details(user_id)
    user_details = json.loads(user_details)
    if user_details:
        user = user_details[0]
        return Response({'ok': True, 'user': user})
    else:
        return Response({'ok': False, 'error': 'Some error occured'})

@api_view(["GET"])
@permission_classes([AllowAny])
def delete_user_method(request, user_id):
    
    deleted = delete_user(user_id)
    if deleted:
        return Response({'ok': True})
    else:
        return Response({'ok': False, 'error': 'Some error occured'})


@api_view(['GET'])
@permission_classes([AllowAny])
def get_all_admin_data(request):

    all_users_data = get_all_users()
    all_institutions_data = get_all_institutions()
    
    if all_institutions_data and all_users_data:
        return Response({'ok': True, 'all_institutions': all_institutions_data, 'all_users': all_users_data }) 
    else:
        return Response({'ok': False, 'error': 'Some error occured'})


# INSTITUTION METHODS

@api_view(['GET'])
@permission_classes([AllowAny])
def get_all_institutions_method(request):

    all_institutions = get_all_institutions()

    if all_institutions:
        return Response({'ok': True, 'all_institutions': all_institutions}) 
    else:
        return Response({'ok': False, 'error': 'Some error occured'})


@api_view(['GET'])
@permission_classes([AllowAny])
def sort_institutions_by_method(request, sort_type):

    all_institutions = []
    if sort_type == 'Rankings':
        all_institutions = sort_by_ranking()
    elif sort_type == 'Ratings':
        all_institutions = sort_by_rating()
    elif sort_type == 'Reviews':
        all_institutions = sort_by_reviews()

    if all_institutions:
        return Response({'ok': True, 'all_institutions': all_institutions}) 
    else:
        return Response({'ok': False, 'error': 'Some error occured'})


@api_view(['GET'])
@permission_classes([AllowAny])
def get_institution_details_method(request, institution_id):
    
    try:
        details = get_institute_details(institution_id)
        reviews = get_institute_reviews(institution_id)
        fees = get_institute_fees_and_expenses(institution_id)
        degrees = get_distinct_degrees(institution_id)
        institute = get_institute_data(institution_id)
        accred_code = get_accredation_code(institution_id)
        code = json.loads(accred_code)[0]['accredCode']
        accred_agency = get_accredation_agency(code)
        degree_program_dict = {}
        degree_list = []
        for obj in json.loads(degrees):
            level = obj['degreeTypeLevel']
            description = obj['degreeTypeDesc']
            temp = {'label': description, 'value': description}
            degree_program_dict[description] = get_distinct_programmes(institution_id, level)
            degree_list.append(temp)
        return Response({'ok': True, 'degree_program_dict': degree_program_dict, 'details': details, 'fees': fees, 'degrees': degree_list, 'reviews': reviews, 'accred_agency': accred_agency, 'institute': institute  })
    except Exception as e:
        return Response({'ok': False, 'error': 'Some error occured'})