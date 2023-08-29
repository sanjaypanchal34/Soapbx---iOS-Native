//
//  LocalizationStrings.swift
//  SoapBx
//
//  Created by Arvind on 24/08/23.
//

import Foundation

enum LocalStrings: String {
    //COMMON
    case C_OK = "c_ok"
    case C_YES = "c_yes"
    case C_NO = "c_no"
    case C_CANCEL = "c_cancel"
    case C_DONE = "c_done"
    case C_RESEND = "c_resend"
    case C_NEXT = "c_next"
    case C_CAMERA = "c_camera"
    case C_GALLERY = "c_gallery"
    case C_MEDIA_TYPE = "c_media_type"
    case C_LOGIN = "c_login"
    case C_FOLLOW = "c_follow"
    case C_UNFOLLOW = "c_unfollow"
    case C_FOLLOWING = "c_following"
    case C_CONFIRM = "c_confirm"
    case C_DELETE = "c_delete"
    case C_REMOVE = "c_remove"
    case C_UNBLOCK = "c_unblock"
    case C_BLOCK = "c_block"
    case C_REQUESTED = "c_requested"
    case C_NO_DATA = "c_no_data"
    case C_SUBMIT = "c_submit"
    case C_OPEN = "c_open"
    
    //ALERT
    case A_LOGOUT = "a_logout"
    case A_DELETE_IMAGE = "a_delete_image"
    case A_DELETE_ACCOUNT = "a_delete_account"
    case A_DELETE_POST = "a_delete_post"
    case A_CHANGE_LANG = "a_change_lang"
    
    //SIDE MENU
    case S_SUPPORT = "s_support"
    case S_BLOG = "s_blog"
    case S_HOME = "s_home"
    case S_POLL = "s_poll"
    case S_FRIEND = "s_friend"
    case S_CONNECTION = "s_connection"
    case S_UPGRADE = "s_upgrade"
    case S_SETTING = "s_setting"
    case S_FAQ = "s_faq"
    case S_ABOUT = "s_about"
    case S_TERMS = "s_terms"
    case S_PRIVACY = "s_privacy"
    case S_LOGOUT = "s_logout"
    
    // LOGIN SCREENS
    case LOGIN_TITLE = "login_title"
    case LOGIN_SUBTITLE = "login_subtitle"
    case BTN_REMEMBER = "btn_remember"
    case BTN_FORGOT_PASS = "btn_forgot_pass"
    case BTN_SIGNIN = "btn_signin"
    case BTN_GUEST = "btn_guest"
    case BTN_SIGNUP = "btn_signup"
    case LBL_NOT_MEMBER = "lbl_not_member"
    
    // VERIFICATION CODE
    case V_TITLE = "v_title"
    case V_DESC_EMAIL = "v_desc_email"
    case V_DESC_PHONE = "v_desc_phone"
    case V_VERIFY = "v_verify"
    
    // PROFILE COVER
    case P_COVER_TITLE = "p_cover_title"
    case P_COVER_ADD = "p_cover_add"
    case P_COVER_DESC = "p_cover_desc"
    case P_COVER_NOTE = "p_cover_note"
    case P_COVER_ALERT = "p_cover_alert"
    
    // FORGOT PASSWORD
    case F_PASS_TITLE = "f_pass_title"
    case F_PASS_STITLE = "f_pass_stitle"
    case F_PASS_PLACEHOLDER = "f_pass_placeholder"
    
    // SIGNUP
    case SIGNUP_TITLE = "signup_title"
    case SIGNUP_STITLE = "signup_stitle"
    case SIGNUP_P_FNAME = "signup_p_fname"
    case SIGNUP_P_LNAME = "signup_p_lname"
    case SIGNUP_P_PNUMBER = "signup_p_pnumber"
    case SIGNUP_P_EMAIL = "signup_p_email"
    case SIGNUP_P_PASSWORD = "signup_p_password"
    case SIGNUP_P_CPASSWORD = "signup_p_cpassword"
    case SIGNUP_P_LOCATION = "signup_p_location"
    case SIGNUP_VERIFY_EMAIL = "signup_verify_email"
    case SIGNUP_VERIFY_NUMBER = "signup_verify_number"
    case SIGNUP_ACCEPT = "signup_accept"
    case SIGNUP_SIGNUP = "signup_signup"
    case SIGNUP_ALREADY_MEMEBER = "signup_already_memeber"
    case SIGNUP_SIGN_IN = "signup_sign_in"
    case SIGNUP_ALERT = "signup_alert"
    
    //SEARCH
    case SEARCH_ALERT = "search_alert"
    case SEARCH_TITLE = "search_title"
    case SEARCH_P_FIGURE = "search_p_figure"
    
    //POLITICIAN
    case POLI_ELECTED = "poli_elected"
    case POLI_VOTER = "poli_voter"
    case POLI_PARTY = "poli_party"
    case POLI_SCORE_TITLE = "poli_score_title"
    case POLI_SCORE_VOTE = "poli_score_vote"
    case POLI_SCORE_MISS_VOTE = "poli_score_miss_vote"
    case POLI_SCORE_MISS_VOTE_PERCENTAGE = "poli_score_miss_vote_percentage"
    case POLI_SCORE_PARTY_PERCENTAGE = "poli_score_party_percentage"
    case POLI_SCORE_AGAINST_PARTY_PERCENTAGE = "poli_score_against_party_percentage"
    case POLI_SCORE_PRESENT = "poli_score_present"
    
    //POLITICIAN CONTACT
    case CONTACT_WEBSITE = "contact_website"
    case CONTACT_FORM = "contact_form"
    case CONTACT = "contact"
    case ALERT_FACEBOOK = "alert_facebook"
    case ALERT_TWITTER = "alert_twitter"
    case ALERT_YOUTUBE = "alert_youtube"
    case ALERT_WEBSITE = "alert_website"
    case ALERT_CONTACT_FORM = "alert_contact_form"
    
    //POLITICIAN BASIC DETAIL
    case P_BASIC_HEADER = "p_basic_header"
    case P_BASIC_TITLE = "p_basic_title"
    case P_BASIC_L_ROLE = "p_basic_l_role"
    case P_BASIC_STATE = "p_basic_state"
    case P_BASIC_STATE_RANK = "p_basic_state_rank"
    case P_BASIC_DOB = "p_basic_dob"
    case P_BASIC_IN_OFFICE = "p_basic_in_office"
    case P_BASIC_SENIOR = "p_basic_senior"
    case P_BASIC_SENATE = "p_basic_senate"
    
    // CREATE POST
    case C_POST_CREATE = "c_post_create"
    case C_POST_EDIT = "c_post_edit"
    case C_POST_ADD_TITLE = "c_post_add_title"
    case C_POST_ABOUT = "c_post_about"
    case C_POST_DESC = "c_post_desc"
    case C_POST_MIND = "c_post_mind"
    case C_POST_ADD_IMAGE = "c_post_add_image"
    case C_POST_ADD_POLITICIAN = "c_post_add_politician"
    case C_POST_ADD_TREND = "c_post_add_trend"
    case C_POST = "c_post"
    case C_POST_UPDATE = "c_post_update"
    
    //PROFILE
    case PROFILE_EDIT = "profile_edit"
    case PROFILE = "profile"
    case PROFILE_DELETE = "profile_delete"
    case PROFILE_MESSAGE = "profile_message"
    case PROFILE_VOCIE = "profile_vocie"
    
    //CHAT
    case CHAT_REQUEST = "chat_request"
    case CHAT_NO_DATA = "chat_no_data"
    
    //NOTIFICATIONS
    case NOTI_TITLE = "noti_title"
    case NOTI_NO_DATA = "noti_no_data"
    
    // REPORT
    case REPORT_WRITE = "report_write"
    case REPORT_REASON = "report_reason"
    case REPORT_TITLE = "report_title"
    
    //COMMENT
    case COMMENT = "comment"
    case COMMENT_ENTER = "comment_enter"
    
    //THREE DOT
    case DOT_OPEN = "dot_open"
    case DOT_HIDE = "dot_hide"
    case DOT_SHARE = "dot_share"
    case DOT_REPORT = "dot_report"
    case DOT_EDIT = "dot_edit"
    case DOT_DELETE = "dot_delete"
    case DOT_CLEAR = "dot_clear"
    case DOT_STAR = "dot_star"
    case DOT_BLOCK = "dot_block"
    
    //FOLLOW
    case F_FOLLOW = "f_follow"
    case F_FOLLOWING = "f_following"
    case F_POLITICIAN = "f_politician"
    
    // PLACE HOLDERS
    case P_EMAIL = "p_email"
    case P_PASSWORD = "p_password"
    case P_LOCATION = "p_location"
    
    // LANGUAGE
    case LANG_ENG = "lang_eng"
    case LANG_SPANISH = "lang_spanish"
    case LANG_FRENCH = "lang_french"
    case LANG_GERMAN = "lang_german"
    case LANG_PORTUGULE = "lang_portugule"
    case LANG_TITLE = "lang_title"
    case LANG_ALERT = "lang_alert"
    
    // PAYMENT
    case PAYMENT_TITLE = "payment_title"
    
    // POST POLL
    case POLL_OPTION = "poll_option"
    case POLL_PLACE_HOLDER = "poll_place_holder"
    case POLL_QUESTION = "poll_question"
    case POLL_QUESTION_P = "poll_question_p"
    case POLL_END_DATE = "poll_end_date"
    case POLL_END_DATE_P = "poll_end_date_p"
    case POLL_START_DATE = "poll_start_date"
    case POLL_START_DATE_P = "poll_start_date_p"
    case POLL_ADD_OPTION = "poll_add_option"
    case POLL_NO_DATA = "poll_no_data"
    case POLL_TITLE = "poll_title"
    
    //CONNECTIONS
    case CONNECTIONS = "connections"
    case CONN_FRIEND = "conn_friend"
    case CONN_BLOCK = "conn_block"
    case CONN_REQUEST = "conn_request"
    case CONN_UNFOLLOW_ACCOUNT = "conn_unfollow_account"
    case CONN_MY_FRIEND = "conn_my_friend"
    
    //CMS
    case FAQ = "faq"
    case ABOUT = "about"
    case TERMS = "terms"
    case PRIVACY = "privacy"
    
    //NOTIFICATION
    case N_PUSH = "n_push"
    case N_DIRECT = "n_direct"
    case N_POST = "n_post"
    case N_NEW = "n_new"
    case N_TITLE = "n_title"
    
    //CHANGE PASSWORD
    case CP_TITLE = "cp_title"
    case CP_OLD = "cp_old"
    case CP_NEW = "cp_new"
    case CP_CNEW = "cp_cnew"
    
    // SUGGEST
    case S_TITLE = "s_title"
    case S_TITLE_FEEDBACK = "s_title_feedback"
    case S_PROFILE = "s_profile"
    case S_EMAIL = "s_email"
    case S_LOCATION = "s_location"
    case S_PNUMBER = "s_pnumber"
    case S_WHAT_IN_MIND = "s_what_in_mind"
    case S_SEND = "s_send"
    
    // SAVED POST
    case SAVED_TITLE = "saved_title"
    
    // INVITE FRIEND
    case I_TITLE = "i_title"
    case I_BUTTON = "i_button"
    
    // ENABLE LOCATION
    case E_TITLE = "e_title"
    case E_MESSAGE = "e_message"
    case E_DESC = "e_desc"
    case E_ENABLE = "e_enable"
    case E_SKIP = "e_skip"
    case E_NOT_DETERMINE = "e_not_determine"
    
    // SUBSCRIBE
    case SUB_TITLE = "sub_title"
    case SUB_TITLE_SETTING = "sub_title_setting"
    case SUB_B_NEXT = "sub_b_next"
    case SUB_B_UPGRADE = "sub_b_upgrade"
    case SUB_B_SUPPORT = "sub_b_support"
    case SUB_MSG = "sub_msg"
    case SUB_ITEM_BLOG = "sub_item_blog"
    case SUB_ITEM_CONDUCT = "sub_item_conduct"
    case SUB_ITEM_PRIORITY = "sub_item_priority"
    case SUB_ITEM_CHOOSE = "sub_item_choose"
    case SUB_ITEM_SOAPBX = "sub_item_soapbx"
    case SUB_ITEM_FEATURE = "sub_item_feature"
    case SUB_ITEM_REWARD = "sub_item_reward"
    case SUB_ITEM_INVITE = "sub_item_invite"
    case SUB_ITEM_F_BLOG = "sub_item_f_blog"
    case SUB_ITEM_F_POLL = "sub_item_f_poll"
    
    // YOU INTREST
    case Y_TITLE = "y_title"
    case Y_TITLE_2 = "y_title_2"
    case Y_NEXT = "y_next"
    case Y_MSG = "y_msg"
}
